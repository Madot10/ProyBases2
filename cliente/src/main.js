import Vue from "vue";
import "./plugins/bootstrap-vue";
import { IconsPlugin } from "bootstrap-vue";
import App from "./App.vue";
import router from "./router";

Vue.config.productionTip = false;

Vue.use(IconsPlugin);

new Vue({
    router,
    render: (h) => h(App),
}).$mount("#app");
