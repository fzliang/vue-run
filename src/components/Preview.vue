<template>
  <div ref="preview" class="preview">
  </div>
</template>

<script lang="ts">
const V = require('vue/dist/vue');
import { Component, Vue, Inject, Provide, Model } from 'vue-property-decorator';
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';


@Component
export default class Preview extends Vue {
  @Model('codeStr') private codeStr: any;
  private tpl: string = '';
  private js: string = '';
  private style: string = '';
  private component: any = null;

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
      this.tpl = `<div id="demo-preview">${this.getTagTpl(this.codeStr, 'template')}</div>`;
      this.js = this.getTagTpl(this.codeStr, 'script').replace(/export default/, `return `);
      this.style = this.getTagTpl(this.codeStr, 'style');
  }
  private renderPreview(): void {
    try {
      this.splitCodeStr();

      if (this.tpl === '' || this.js === '') {
          throw new Error('template or script not found');
      }

      const e = new Function(this.js)();
      e.template = this.tpl;

      const ext = V.extend(e);
      ext.use(ElementUI);

      if (this.component = (new ext).$mount(),
        (this.$refs.preview as any).appendChild(this.component.$el),
        '' !== this.style
      ) {
        const styleEle = document.createElement('style');
        styleEle.type = 'text/css';
        styleEle.id = 'preview-style';
        styleEle.innerHTML = this.style;
        document.getElementsByTagName('head')[0].appendChild(styleEle);
      }
    } catch (e) {
      console.error(e);
    }
  }

  private destoryPreview(): void {
    const styleEle = document.getElementById('preview-style');
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

</style>
