import Vue from "vue";
import VueRouter from "vue-router";
import Menu from "../views/Menu.vue";

Vue.use(VueRouter);

const routes = [
    {
        path: "/",
        name: "Home",
        component: Menu,
    },
    {
        path: "/reportes",
        name: "Reportes",
        component: () => import("../views/MenuReportes.vue"),
    },
    /*{
        path: "/about",
        name: "About",
        component: () => import("../views/Home.vue"),
    },*/
];

const router = new VueRouter({
    mode: "history",
    base: process.env.BASE_URL,
    routes,
});

export default router;
