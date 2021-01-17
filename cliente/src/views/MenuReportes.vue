<template>
    <ScreenWindow>
        <b-toast id="error-toast" title="Error" variant="danger">
            ¡No se puede ejecutar el reporte seleccionado!
        </b-toast>
        <b-container class="h-100">
            <b-row class="h-100" align-v="center">
                <b-col>
                    <h1>Reportes Le Mans</h1>
                    <b-card-group columns>
                        <b-card title="1- Ranking por año">
                            <b-card-text
                                >Reporte detallado del ranking de la carrera de Le Mans por
                                año.</b-card-text
                            >
                            <b-button
                                href="#"
                                @click="abrir_modal_reportes(1)"
                                block
                                variant="primary"
                                >EJECUTAR</b-button
                            >
                        </b-card>

                        <b-card title="2- Ranking hora por hora">
                            <b-card-text>
                                Reporte detallado del ranking de la carrera de Le Mans por
                                hora.</b-card-text
                            >
                            <b-button
                                href="#"
                                @click="abrir_modal_reportes(2)"
                                block
                                variant="primary"
                                >EJECUTAR</b-button
                            >
                        </b-card>

                        <b-card title="3- Ganadores de las 24 horas de Le Mans">
                            <b-card-text>
                                Reporte que muestra los ganadores por categoría de la carrera por
                                año</b-card-text
                            >
                            <b-button
                                href="#"
                                @click="abrir_modal_reportes(3)"
                                block
                                variant="primary"
                                >EJECUTAR</b-button
                            >
                        </b-card>

                        <b-card title="4- Resultados por nro. de equipo">
                            <b-card-text>
                                Reporte detallado del ranking de la carrera de Le Mans por año de un
                                nro. de equipo.</b-card-text
                            >
                            <b-button
                                href="#"
                                @click="abrir_modal_reportes(4)"
                                block
                                variant="primary"
                                >EJECUTAR</b-button
                            >
                        </b-card>

                        <b-card title="5- Logros por piloto">
                            <b-card-text>
                                Reporte detallado de las participaciones de un piloto</b-card-text
                            >
                            <b-button
                                href="#"
                                @click="abrir_modal_reportes(5)"
                                block
                                variant="primary"
                                >EJECUTAR</b-button
                            >
                        </b-card>

                        <b-card title="6- Participaciones marca y modelo de auto">
                            <b-card-text>
                                Reporte de las participaciones según marca y modelo</b-card-text
                            >
                            <b-button
                                href="#"
                                @click="abrir_modal_reportes(6)"
                                block
                                variant="primary"
                                >EJECUTAR</b-button
                            >
                        </b-card>

                        <b-card title="7- Piloto más joven del año en Le Mans">
                            <b-card-text>
                                Reporte que muestra el conductor más joven al inicio de cada una de
                                las ediciones de la carrera.</b-card-text
                            >
                            <b-button
                                href="#"
                                @click="abrir_modal_reportes(7)"
                                block
                                variant="primary"
                                >EJECUTAR</b-button
                            >
                        </b-card>

                        <b-card title="8- Piloto más veterano del año en Le Mans">
                            <b-card-text>
                                Reporte que muestra el conductor más veterano al inicio de cada una
                                de las ediciones de la carrera.</b-card-text
                            >
                            <b-button
                                href="#"
                                @click="abrir_modal_reportes(8)"
                                block
                                variant="primary"
                                >EJECUTAR</b-button
                            >
                        </b-card>

                        <b-card title="9- Mayor número de participaciones en Le Mans">
                            <b-card-text>
                                Reporte que muestra el número más alto de participaciones por
                                piloto.</b-card-text
                            >
                            <b-button href="#" :to="{ name: 'Reporte 9' }" block variant="primary"
                                >EJECUTAR</b-button
                            >
                        </b-card>

                        <b-card title="16- Mujeres piloto en Le mans">
                            <b-card-text>
                                Reporte que muestra el registro de participaciones de mujeres piloto
                                en la carrera.</b-card-text
                            >
                            <b-button
                                href="#"
                                @click="abrir_modal_reportes(16)"
                                block
                                variant="primary"
                                >EJECUTAR</b-button
                            >
                        </b-card>
                    </b-card-group>

                    <modal-opciones-reportes :reporte="reporte_selected"></modal-opciones-reportes>
                    <modal-opciones-nuevas-rep
                        :reporte="reporte_selected"
                    ></modal-opciones-nuevas-rep>
                </b-col>
            </b-row>
        </b-container>
    </ScreenWindow>
</template>

<script>
import ScreenWindow from "../components/ScreenWindow.vue";
import ModalOpcionesReportes from "../components/ModalOpcionesReportes.vue";
import ModalOpcionesNuevasRep from "../components/ModalNuevasOpcionesRep.vue";

export default {
    components: { ScreenWindow, ModalOpcionesReportes, ModalOpcionesNuevasRep },
    data() {
        return {
            reporte_selected: 0,
        };
    },
    methods: {
        abrir_modal_reportes(nro_reporte) {
            this.reporte_selected = nro_reporte;
            if (nro_reporte < 4) {
                this.$bvModal.show("modal-reportes");
            } else {
                this.$bvModal.show("modal-new-reportes");
            }
        },
    },
    mounted() {
        console.log("Montando interfaz menu", this.$route.params.error);
        let is_error = this.$route.params.error === 1 ? true : false;
        if (is_error) {
            //Mostrar aviso
            this.$bvToast.show("error-toast");
        }

        this.$root.$on("bv::modal::hidden", (bvEvent, modalId) => {
            console.warn("Cerrando modal");
            if (modalId == "modal-new-reportes") {
                this.reporte_selected = 0;
            }
        });
    },
};
</script>

<style></style>
