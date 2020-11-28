<template>
    <ScreenWindow>
        <b-container class="h-100">
            <b-row class="h-100" align-v="center">
                <b-col col></b-col>
                <b-col cols="9" md="6">
                    <h1>Reportes Le Mans</h1>
                    <b-list-group>
                        <b-list-group-item href="#" class="flex-column align-items-start">
                            <div class="d-flex w-100 justify-content-between">
                                <h5 class="mb-1">Ranking por año</h5>
                            </div>

                            <p class="mb-1">
                                Reporte detallado del ranking de la carrera de Le Mans por año.
                            </p>
                        </b-list-group-item>

                        <b-list-group-item href="#" class="flex-column align-items-start">
                            <div class="d-flex w-100 justify-content-between">
                                <h5 class="mb-1">Raking hora por hora</h5>
                            </div>

                            <p class="mb-1">
                                Reporte detallado del ranking de la carrera de Le Mans por hora.
                            </p>
                        </b-list-group-item>

                        <b-list-group-item href="#" class="flex-column align-items-start">
                            <div class="d-flex w-100 justify-content-between">
                                <h5 class="mb-1">Ganadores de las 24 horas de Le Mans</h5>
                            </div>

                            <p class="mb-1">
                                Reporte que muestra los ganadores por categoría de la carrera por
                                año
                            </p>
                        </b-list-group-item>
                    </b-list-group>
                </b-col>
                <b-col col></b-col>
            </b-row>
        </b-container>
    </ScreenWindow>
</template>

<script>
import ScreenWindow from "../components/ScreenWindow.vue";

export default {
    components: { ScreenWindow },
};
</script>

<style></style>
