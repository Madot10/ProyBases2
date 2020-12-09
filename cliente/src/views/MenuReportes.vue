<template>
    <ScreenWindow>
        <b-container class="h-100">
            <b-row class="h-100" align-v="center">
                <b-col col></b-col>
                <b-col cols="9" md="6">
                    <h1>Reportes Le Mans</h1>
                    <b-list-group>
                        <b-list-group-item
                            href="#"
                            @click="abrir_modal_reportes(1)"
                            class="flex-column align-items-start"
                        >
                            <div class="d-flex w-100 justify-content-between">
                                <h5 class="mb-1">Ranking por año</h5>
                            </div>

                            <p class="mb-1">
                                Reporte detallado del ranking de la carrera de Le Mans por año.
                            </p>
                        </b-list-group-item>

                        <b-list-group-item
                            href="#"
                            @click="abrir_modal_reportes(2)"
                            class="flex-column align-items-start"
                        >
                            <div class="d-flex w-100 justify-content-between">
                                <h5 class="mb-1">Raking hora por hora</h5>
                            </div>

                            <p class="mb-1">
                                Reporte detallado del ranking de la carrera de Le Mans por hora.
                            </p>
                        </b-list-group-item>

                        <b-list-group-item
                            href="#"
                            @click="abrir_modal_reportes(3)"
                            class="flex-column align-items-start"
                        >
                            <div class="d-flex w-100 justify-content-between">
                                <h5 class="mb-1">Ganadores de las 24 horas de Le Mans</h5>
                            </div>

                            <p class="mb-1">
                                Reporte que muestra los ganadores por categoría de la carrera por
                                año
                            </p>
                        </b-list-group-item>
                    </b-list-group>
                    <modal-opciones-reportes :reporte="reporte_selected"></modal-opciones-reportes>
                </b-col>
                <b-col col></b-col>
            </b-row>
        </b-container>
    </ScreenWindow>
</template>

<script>
import ScreenWindow from "../components/ScreenWindow.vue";
import ModalOpcionesReportes from "../components/ModalOpcionesReportes.vue";

export default {
    components: { ScreenWindow, ModalOpcionesReportes },
    data() {
        return {
            reporte_selected: 0,
        };
    },
    methods: {
        abrir_modal_reportes(nro_reporte) {
            this.reporte_selected = nro_reporte;
            this.$bvModal.show("modal-reportes");
        },
    },
};
</script>

<style></style>
