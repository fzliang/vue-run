<template>
  <div>
    <div ref="preview" class="preview">
      <pre class="err-msg">{{errMsg}}</pre>
    </div>
  </div>
</template>

<script lang="ts">
const V = require('vue/dist/vue');
import { Component, Vue, Inject, Provide, Model } from 'vue-property-decorator';
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';

const divId= `demo-preview-` + new Date().getTime()

@Component
export default class Preview extends Vue {
  @Model('codeStr') private codeStr: any;
  private tpl: string = '';
  private js: string = '';
  private style: string = '';
  private component: any = null;
  private errMsg: any = '';

  public run(): void {
    this.destoryPreview();
    this.renderPreview();
  }


  private getTagTpl(tpl: string, tag: string): string {
    const reg: RegExp = new RegExp('<' + tag + '[^>]*>');
    const regRes: RegExpMatchArray | null = tpl.match(reg);
    let res: string = '';
    return regRes
      ? (res = regRes[0], tpl.slice(tpl.indexOf(res as string) + res.length, tpl.lastIndexOf(`</${tag}>`)))
      : res;
  }

  private splitCodeStr(): void {
      this.tpl = `<div id="${divId}">${this.getTagTpl(this.codeStr, 'template')}</div>`;
      this.js = this.getTagTpl(this.codeStr, 'script').replace(/export default/, `return `);
      this.style = this.getTagTpl(this.codeStr, 'style');
  }
  private renderPreview(): void {
    try {
      this.splitCodeStr();

      if (this.tpl === '' || this.js === '') {
         return;
      }

      const e = new Function(this.js)();
      e.template = this.tpl;

      const ext = V.extend(e);
      ext.use(ElementUI);

      if (this.component = (new ext!).$mount(),
        (this.$refs.preview as any).appendChild(this.component.$el),
        '' !== this.style
      ) {
        const id = 
        this.style = this.style
          .replace(/[\r\n]/g, ' ').replace(/\s+/g, ' ')
          .replace(/^(?:\s*)([^}|{])*(?={)/, ($1) => '#' + divId + ' ' + $1)
          .replace(/(?<=})([^}|{])*(?={)/g, ($1) => '#' + divId + ' ' + $1)

        const styleEle = document.createElement('style') as any;
        styleEle.type = 'text/css';
        styleEle.id = 'preview-style';
        styleEle.innerHTML = this.style;
        document.getElementsByTagName('head')[0].appendChild(styleEle);
      }
    } catch (ex) {
        console.log(ex.message)
        let head = `[Vue warn]: Error in render: "`;
        let tail = `(found in <Root>)`;

        let msg = ex.message;
        let start = msg.indexOf(head) > -1? msg.indexOf(head) + length : 0;
        let end = msg.indexOf(tail) > -1? msg.indexOf(tail) : msg.length;

        this.errMsg = msg.slice(start, end);
        console.log(this.errMsg)
    }
  }

  private destoryPreview(): void {
    const styleEle = document.getElementById('preview-style');
    this.errMsg = ''
    styleEle && styleEle!.parentNode!.removeChild(styleEle);
    if (this.component !== null) {
        (this.$refs.preview as any).removeChild(this.component.$el);
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
