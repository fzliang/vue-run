<template>
  <div id="app">
    <header class="header">
      <div class="logo">
        <img alt="Vue logo" src="./assets/logo.png" />
        <span class="title">Vue-Element-Run</span>
      </div>
      <ul class="nav">
        <li>
          <a class="nav-link contribute" @click="run"><i class="icon iconfont icon-kuaisuyunxing01"></i> 运行</a>
        </li>
      </ul>
    </header>
    <div class="main">
      <div class="item">
        <Editor v-model="codeStr"></Editor>
      </div>
      <div class="item">
        <Preview v-model="codeStr" ref="previewComp"></Preview>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';
import Editor from './components/Editor.vue';
import Preview from './components/Preview.vue';
import './assets/style/reset.css';

@Component({
  components: {
      Preview,
      Editor,
  },
})
export default class App extends Vue {
    public codeStr: string = `<template>
  <div>
   <span>{{msg}}</span>
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

  public run() {
    (this.$refs.previewComp as any).run();
  }

  public mounted() {
    this.run();
  }
}
</script>

<style lang="less">
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
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
    box-shadow: 0 0 2px rgba(0,0,0,0.25);
    padding: 5px 20px;
    position: relative;
    .logo {
      display: inline-block;
      font-size: 18px;
      line-height: 40px;
      color: #2c3e50;
      font-family: "Dosis", "Source Sans Pro", "Helvetica Neue", Arial, sans-serif;
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
      left: 250px;
      top: 10px;
      height: 40px;
      line-height: 30px;
      li {
        display: inline-block;
        position: relative;
        margin: 0 0.6em;
        .nav-link{
          padding-bottom: 3px;
          white-space: nowrap;
          font-size: 15px;
          cursor: pointer;
          .contribute {
            margin-left: 10px;
          }
          &:hover {
            color: #0086b3;
          }
        }
      }
    }
  }
  .main {
    display: flex;
    flex-wrap: wrap;
    width: 100%;
    padding-top: 10px;
    position: relative;
    div.item {
      min-width: 300px;
      flex-grow: 1;
      padding: 5px 10px;
      overflow: scroll;
      @media (min-width: 600px){
        max-width: calc(50% - 10px);
        height: calc(100vh - 80px);
        &:not(:last-of-type) {
          border-right: 1px solid #e9e9e9;
        }
      }

      @media (max-width: 600px){
        &:not(:last-of-type) {
          border-bottom: 1px solid #e9e9e9;
        }
        &:last-of-type {
          margin-top: 10px;
        }
      }

    }
  }
}
</style>
