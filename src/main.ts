import Vue from 'vue';
import App from './App.vue';

Vue.config.productionTip = false;

const consoleError = window.console.error;
window.console.error = (...args: any) => {
    const errMsg = args && args[0].toString();
    if (errMsg.indexOf(`[Vue warn]`) > -1) {
        throw new Error(errMsg);
    }
    consoleError && consoleError.apply(window, args);
};

new Vue({
  render: (h) => h(App),
}).$mount('#app');
