<template>
    <ScreenWindow>
        <b-toast id="error-toast" title="Error" variant="danger">
            ¡No se puede ejecutar el reporte seleccionado!
        </b-toast>
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
                                <h5 class="mb-1">Ranking hora por hora</h5>
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
    mounted() {
        console.log("Montando interfaz menu", this.$route.params.error);
        let is_error = this.$route.params.error === 1 ? true : false;
        if (is_error) {
            //Mostrar aviso
            this.$bvToast.show("error-toast");
        }
    },
};
</script>

<style></style>
