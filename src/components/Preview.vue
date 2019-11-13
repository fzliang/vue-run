<template>
  <div>
    <div ref="preview" class="preview">
      <pre class="err-msg">{{ errMsg }}</pre>
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Model, Prop } from 'vue-property-decorator';
import axios from 'axios';
import { VueConstructor } from 'vue/types/vue';

const divId = `demo-preview-` + new Date().getTime();

@Component
export default class Preview extends Vue {
  @Prop(String) public eleVersion!: string;
  @Prop(String) public vueVersion!: string;
  @Model('codeStr') private codeStr!: string;
  private tpl: string = '';
  private js: string = '';
  private style: string = '';
  private component: Vue | null = null;
  private errMsg: string = '';

  public run(): void {
    this.destoryPreview();
    this.renderPreview();
  }

  private getTagTpl(tpl: string, tag: string): string {
    const reg: RegExp = new RegExp('<' + tag + '[^>]*>');
    const regRes: RegExpMatchArray | null = tpl.match(reg);
    let res: string = '';
    return regRes
      ? ((res = regRes[0]),
        tpl.slice(
          tpl.indexOf(res as string) + res.length,
          tpl.lastIndexOf(`</${tag}>`),
        ))
      : res;
  }

  private splitCodeStr(): void {
    this.tpl = `<div id="${divId}">${this.getTagTpl(
      this.codeStr,
      'template',
    )}</div>`;
    this.js = this.getTagTpl(this.codeStr, 'script').replace(
      /export default/,
      `return `,
    );
    this.style = this.getTagTpl(this.codeStr, 'style');
  }

  private renderPreview(): void {
    const getVue: Promise<any> = axios.get(
      `/vue/${this.vueVersion}/vue.min.js`,
    );
    const getElem: Promise<any> = axios.get(
      `/element-ui/${this.eleVersion}/index.js`,
    );

    const oldLinkEle: HTMLElement | null = document.getElementById(
      'preview-link',
    );
    if (oldLinkEle instanceof HTMLElement) {
      oldLinkEle!.parentNode!.removeChild(oldLinkEle);
    }

    const linkEle: HTMLLinkElement = document.createElement(
      'link',
    ) as HTMLLinkElement;

    linkEle.href = `element-ui/${this.eleVersion}/theme-chalk/index.css`;
    linkEle.id = 'preview-link';
    linkEle.setAttribute('type', 'text/css');
    linkEle.setAttribute('rel', 'stylesheet');
    document.getElementsByTagName('head')[0].appendChild(linkEle);

    Promise.all([getVue, getElem]).then((res) => {
      const VueFunc = new Function(res[0].data);
      const VueInstance: VueConstructor = new VueFunc.prototype.constructor()
        .Vue;

      const Ele = new Function(
        'vueInstance',
        `this.Vue = vueInstance; return ${res[1].data};`,
      );

      Ele(VueInstance);

      this.renderPreviewHandler(VueInstance);
    });
  }

  private renderPreviewHandler(V: VueConstructor): void {
    try {
      this.splitCodeStr();

      if (this.tpl === '' || this.js === '') {
        return;
      }

      const e = new Function(this.js)();
      e.template = this.tpl;

      const ext = V.extend(e);

      this.component = new ext!().$mount();
      (this.$refs.preview as HTMLElement).appendChild(this.component.$el);

      if ('' !== this.style) {
        this.style = this.style
          .replace(/[\r\n]/g, ' ')
          .replace(/\s+/g, ' ')
          // .replace(/^(?:\s*)([^}|{])*(?={)/, ($1) => '#' + divId + ' ' + $1)
          // .replace(/(?<=[}|,])([^}|{])*(?={)/g, ($1) => '#' + divId + ' ' + $1)
          .replace(/^(\s*)([^}|{]*)({)/, `#${divId} $2 $3`)
          .replace(/([}|,])([^}|{]*)({)/g, `$1 #${divId} $2 $3`);

        const styleEle: HTMLStyleElement = document.createElement('style');
        styleEle.type = 'text/css';
        styleEle.id = 'preview-style';
        styleEle.innerHTML = this.style;
        document.getElementsByTagName('head')[0].appendChild(styleEle);
      }
    } catch (ex) {
      const head: string = `[Vue warn]: Error in render: "`;
      const tail: string = `(found in <Root>)`;

      const msg: string = ex.message;
      const start: number =
        msg.indexOf(head) > -1 ? msg.indexOf(head) + head.length : 0;
      const end: number =
        msg.indexOf(tail) > -1 ? msg.indexOf(tail) : msg.length;

      this.errMsg = msg.slice(start, end);
    }
  }

  private destoryPreview(): void {
    const styleEle: HTMLElement | null = document.getElementById(
      'preview-style',
    );
    this.errMsg = '';
    if (styleEle) {
      styleEle!.parentNode!.removeChild(styleEle);
    }
    if (this.component !== null) {
      (this.$refs.preview as HTMLElement).removeChild(this.component.$el);
      this.component!.$destroy();
      this.component = null;
    }
  }

  private mounted() {
    this.$on('run', () => {
      this.run();
    });
  }
}
</script>

<style scoped lang="less">
.err-msg {
  color: red;
  white-space: pre-wrap;
}
</style>
