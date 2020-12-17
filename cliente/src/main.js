import Vue from "vue";
import "./plugins/bootstrap-vue";
import { IconsPlugin } from "bootstrap-vue";
import App from "./App.vue";
import router from "./router";
import Donut from "vue-css-donut-chart";
import "vue-css-donut-chart/dist/vcdonut.css";

Vue.config.productionTip = false;

Vue.use(Donut);
Vue.use(IconsPlugin);

new Vue({
    router,
    render: (h) => h(App),
}).$mount("#app");
