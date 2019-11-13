<template>
  <codemirror
    :value="code"
    :options="cmOptions"
    @input="onCmCodeChange"
  ></codemirror>
</template>
<script lang="ts">
import { Component, Vue, Model, Emit, Prop } from 'vue-property-decorator';

// const {codemirror} = require('vue-codemirror');
import { codemirror } from 'vue-codemirror';
import 'codemirror/lib/codemirror.css';
import 'codemirror/mode/htmlmixed/htmlmixed.js';

@Component({
  components: {
    codemirror,
  },
})
export default class Editor extends Vue {
  @Prop()
  @Model('change', { type: String })
  private code: any;

  private cmOptions = {
    // codemirror options
    tabSize: 2,
    mode: 'htmlmixed',
    // theme: 'base16-dark',
    lineNumbers: true,
    line: true,
    // more codemirror options, 更多 codemirror 的高级配置...
  };

  @Emit('change')
  private onCmCodeChange(newCode: string) {}
}
</script>
<style lang="less">
.vue-codemirror {
  position: relative;
  height: 100%;
}
.CodeMirror {
  /*border: 1px solid #eee;*/
  height: 100%;
}
.CodeMirror-scroll {
  height: 100%;
  overflow-y: hidden;
  overflow-x: auto;
}
</style>
