<template>
    <ScreenWindow>
        <b-container class="h-100 ">
            <b-row class="h-100" align-v="center">
                <h3 class="text-center mb-2 w-100">
                    Pilotos
                </h3>

                <div v-for="(parti, i) in datos_pilotos" :key="i" class="w-100">
                    <CardPiloto :datos="parti" reporte="13"></CardPiloto>
                    <br />
                </div>

                <!-- MENSAJE - CARGA -->
                <div v-show="is_loading == true" class="mt-2 text-center mx-auto">
                    <h3>Estamos solicitando la información al servidor, por favor espere</h3>
                    <b-icon icon="circle-fill" animation="throb" font-scale="4"></b-icon>
                </div>
            </b-row>
        </b-container>
    </ScreenWindow>
</template>

<script>
import ScreenWindow from "../components/ScreenWindow.vue";
import CardPiloto from "../components/CardPiloto.vue";

export default {
    components: { ScreenWindow, CardPiloto },
    data() {
        return {
            datos_pilotos: [],
            is_loading: true,
        };
    },
    methods: {
        //Obtener datos desde el MBD
        obtener_datos() {
            let urlApi = `http://localhost:3000/podium`;

            //Solicitamos datos
            fetch(urlApi)
                .then((response) => {
                    return response.json();
                })
                .then((ranking_data) => {
                    //this.generar_rank(ranking_data);
                    console.log(ranking_data);
                    this.datos_pilotos = ranking_data;
                    this.is_loading = false;
                })
                .catch((err) => {
                    console.log("ERROR desde SV", err);
                    this.$router.push({
                        name: "Reportes",
                        params: {
                            error: 1,
                        },
                    });
                });
        },
    },
    created() {
        this.obtener_datos();
    },
};
</script>

<style></style>
