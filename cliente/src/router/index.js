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
        path: "/ganadores-le-mans/:anno_sel/:cat_sel",
        name: "Reporte 3",
        component: () => import("../views/Reporte3.vue"),
    },
    //Reporte 4
    {
        path: "/ranking-equipo/:anno_sel/:nro_sel",
        name: "Reporte 4",
        component: () => import("../views/Reporte4.vue"),
    },
    //Reporte 5
    {
        path: "/logros-piloto/:pilot_sel",
        name: "Reporte 5",
        component: () => import("../views/Reporte5.vue"),
    },
    //Reporte 6
    {
        path: "/participaciones-marca-modelo/:fab_sel/:model_sel",
        name: "Reporte 6",
        component: () => import("../views/Reporte6.vue"),
    },
    //Reporte 7y8
    {
        path: "/carrera-pilotos/:v/:anno_sel",
        name: "Reporte 7y8",
        component: () => import("../views/Reporte78.vue"),
    },
    //Reporte 9
    {
        path: "/piloto_mayores_part",
        name: "Reporte 9",
        component: () => import("../views/Reporte9.vue"),
    },
    {
        path: "/simulacion/:anno_ref/:pista/:clima",
        name: "Simulacion",
        component: () => import("../views/Sim.vue"),
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
