import Vue from "vue";
import VueRouter from "vue-router";
import Menu from "../views/Menu.vue";

Vue.use(VueRouter);

const routes = [
    //Menu principal
    {
        path: "/",
        name: "Home",
        component: Menu,
    },
    //Menu reportes
    {
        path: "/reportes",
        name: "Reportes",
        component: () => import("../views/MenuReportes.vue"),
    },
    //Reporte 1
    {
        path: "/ranking-anno/:anno_sel/:cat_sel/:event_sel",
        name: "Reporte 1",
        component: () => import("../views/Reporte1.vue"),
    },
    //Reporte 2
    {
        path: "/ranking-hora/:anno_sel/:cat_sel/:hora_sel",
        name: "Reporte 2",
        component: () => import("../views/Reporte2.vue"),
    },
    //Reporte 3
    {
        path: "/ganadores-le-mans/:anno_sel",
        name: "Reporte 3",
        component: () => import("../views/Reporte3.vue"),
    },
    /* 404 => REDIRECT  */
    {
        path: "*",
        redirect: { name: "Home" },
    },
];

const router = new VueRouter({
    mode: "history",
    base: process.env.BASE_URL,
    routes,
});

export default router;
