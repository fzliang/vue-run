<template>
  <div id="app">
    <header class="header">
      <div class="logo">
        <img alt="Vue logo" src="./assets/logo.png" />
        <span class="title">Vue-Element-Run</span>
      </div>
      <ul class="nav">
        <li>
          Vue版本
          <select v-model="vueVersion">
            <option v-for="item in vueVersionList" :key="item">
              {{ item }}
            </option>
          </select>
        </li>
        <li>
          Element版本
          <select v-model="eleVersion">
            <option v-for="item in eleVersionList" :key="item">
              {{ item }}
            </option>
          </select>
        </li>
        <li>
          <a class="nav-link contribute" @click="run">
            <i class="icon iconfont icon-kuaisuyunxing01"></i> 运行
          </a>
        </li>
      </ul>
    </header>
    <div class="main">
      <div class="item" id="codeBlock">
        <Editor v-model="codeStr"></Editor>
      </div>
      <div id="split-trigger" class="split-trigger split-trigger-vertical">
        <div class="split-trigger-bar-con vertical">
          <i class="split-trigger-bar"></i>
          <i class="split-trigger-bar"></i>
          <i class="split-trigger-bar"></i>
          <i class="split-trigger-bar"></i>
          <i class="split-trigger-bar"></i>
          <i class="split-trigger-bar"></i>
        </div>
      </div>
      <div class="item" id="rightItem">
        <Preview
          v-model="codeStr"
          ref="previewComp"
          :vueVersion="vueVersion"
          :eleVersion="eleVersion"
        ></Preview>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';
import Editor from './components/Editor.vue';
import Preview from './components/Preview.vue';
import './assets/style/reset.css';
import { ELE_VERSION } from './constant/EleVersion';
import { VUE_VERSION } from './constant/VueVersion';

@Component({
  components: {
    Preview,
    Editor,
  },
})
export default class App extends Vue {
  private codeStr: string = `<template>
  <div>
   <el-alert :title="msg" type="success" />
  </div>
</template>

<script>
  export default {
    data () {
      return {
        msg: 'Hello, Vue!'
      }
    },
    methods: {

    }
  }
<\/script>

<style>

</style>
`;

  private vueVersionList: string[] = VUE_VERSION;
  private eleVersionList: string[] = ELE_VERSION;

  private vueVersion: string = VUE_VERSION[0];
  private eleVersion: string = ELE_VERSION[0];

  private run() {
    (this.$refs.previewComp as any).run();
  }

  private splitMove() {
    const splitTriggerEle: any | null = document.getElementById(
      'split-trigger',
    );

    function onMouseMove(event: MouseEvent | null) {
      const mouseMoveEvent: any = event || window.event;
      let leftItemWidth = mouseMoveEvent.x;

      if (leftItemWidth < 100) {
        leftItemWidth = 100;
      } else if (leftItemWidth > document.body.clientWidth - 100) {
        leftItemWidth = document.body.clientWidth - 100;
      }

      document
        .getElementById('codeBlock')!
        .setAttribute('style', 'width: ' + leftItemWidth + 'px');

      const rightWidth = document.body.clientWidth - leftItemWidth - 6;
      document
        .getElementById('rightItem')!
        .setAttribute('style', 'width: ' + rightWidth + 'px');
    }

    function onMouseUp() {
      document.onmousemove = null;
      document.onmouseup = null;
    }

    function onMouseDownCb(event: MouseEvent | null) {
      const mouseDownEvent: any = event || window.event;
      const disX = mouseDownEvent.offsetX;

      document.onmousemove = onMouseMove;
      document.onmouseup = onMouseUp;
    }

    if (splitTriggerEle) {
      splitTriggerEle.onmousedown = onMouseDownCb;
    }
  }

  private bindKeyDown(event: KeyboardEvent) {
    if ((event.ctrlKey || event.metaKey) && event.keyCode === 83) {
      this.run();
      return false;
    }
  }

  private created() {
    document.onkeydown = this.bindKeyDown;
  }

  private mounted() {
    this.run();
    this.splitMove();
  }
}
</script>

<style lang="less">
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  height: 100%;
  .header {
    top: 0;
    left: 0;
    /*width: 100%;*/
    height: 40px;
    background-color: #fff;
    z-index: 9;
    box-shadow: 0 0 2px rgba(0, 0, 0, 0.25);
    padding: 5px 20px;
    position: relative;
    .logo {
      display: inline-block;
      font-size: 18px;
      line-height: 40px;
      color: #2c3e50;
      font-family: "Dosis", "Source Sans Pro", "Helvetica Neue", Arial,
        sans-serif;
      font-weight: 500;
      img {
        vertical-align: middle;
        margin-right: 6px;
        width: 30px;
        height: 30px;
      }
    }
    .nav {
      list-style-type: none;
      margin: 0;
      padding: 0;
      position: absolute;
      left: 210px;
      top: 10px;
      height: 40px;
      line-height: 30px;
      li {
        display: inline-block;
        position: relative;
        margin: 0 0.6em;
        .nav-link {
          padding-bottom: 3px;
          white-space: nowrap;
          font-size: 15px;
          cursor: pointer;
          &:hover {
            color: #0086b3;
          }
        }
        .contribute {
          margin-left: 10px;
        }
      }
    }
  }
  .main {
    display: flex;
    // flex-wrap: wrap;
    width: 100%;
    // padding-top: 10px;
    position: relative;
    div.item {
      // padding: 5px 10px;
      overflow: scroll;
      width: calc(50% - 3px);
      height: calc(100vh - 40px);
      // @media (min-width: 600px){
      //   width: calc(50% - 50px);
      //   height: calc(100vh - 40px);
      // }

      // @media (max-width: 600px){
      //   &:not(:last-of-type) {
      //     border-bottom: 1px solid #e9e9e9;
      //   }
      //   &:last-of-type {
      //     margin-top: 10px;
      //   }
      // }
    }

    .split-trigger {
      border: 1px solid #dcdee2;
    }

    .split-trigger-vertical {
      width: 6px;
      // height: 100%;
      background: #f8f8f9;
      border-top: none;
      border-bottom: none;
      cursor: col-resize;

      @media (max-width: 600px) {
        &:not(:last-of-type) {
          display: none;
        }
      }

      display: flex;
      justify-content: center;
      align-items: center;
    }

    .split-trigger-bar-con.vertical {
      display: flex;
      flex-direction: column;
      height: 32px;
    }
    .split-trigger-bar {
      width: 4px;
      height: 1px;
      background: rgba(23, 35, 61, 0.25);
      float: left;
      margin-top: 3px;
    }
  }
}
</style>
