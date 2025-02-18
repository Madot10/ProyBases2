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
    //Reporte 10
    {
        path: "/ganador_primer_part/:anno_sel",
        name: "Reporte 10",
        component: () => import("../views/Reporte10.vue"),
    },
    //Reporte 11
    {
        path: "/mejores_vel/:ord_sel/:anno_sel",
        name: "Reporte 11",
        component: () => import("../views/Reporte11.vue"),
    },
    //Reporte 12
    {
        path: "/mejores_dist/:limit_sel",
        name: "Reporte 12",
        component: () => import("../views/Reporte12.vue"),
    },
    //Reporte 13
    {
        path: "/podium",
        name: "Reporte 13",
        component: () => import("../views/Reporte13.vue"),
    },
    //Reporte 14
    {
        path: "/abandonos",
        name: "Reporte 14",
        component: () => import("../views/Reporte14.vue"),
    },
    //Reporte 15
    {
        path: "/victorias-marcas/:isauto_sel",
        name: "Reporte 15",
        component: () => import("../views/Reporte15.vue"),
    },
    //Reporte 16
    {
        path: "/mujeres-piloto/:anno_sel",
        name: "Reporte 16",
        component: () => import("../views/Reporte16.vue"),
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
