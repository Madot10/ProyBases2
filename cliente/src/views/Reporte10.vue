<template>
    <ScreenWindow>
        <b-container class="h-100 ">
            <b-row class="h-100" align-v="center">
                <h3 class="text-center mb-2 w-100">
                    Ganador en su primera participación
                </h3>

                <div v-for="(parti, i) in data_parti" :key="i" class="w-100">
                    <CardPiloto :datos="parti"></CardPiloto>
                    <br />
                </div>

                <!-- MENSAJE - DATOS VACIOS -->
                <div
                    v-show="data_parti.length == 0 && is_loading == false"
                    class="mt-2 text-center  mx-auto"
                >
                    <h2>¡No hemos encontrado información!</h2>
                    <b-icon class="h1" icon="emoji-frown"></b-icon>
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
            data_parti: [],
            is_loading: false,
        };
    },
    methods: {
        retornar_error() {
            this.$router.push({
                name: "Reportes",
                params: {
                    error: 1,
                },
            });
        },
        //Obtener datos desde el MBD
        obtener_datos() {
            let urlApi = `http://localhost:3000/ganador_primer_part/${this.$route.params.anno_sel}`;

            //Solicitamos datos
            fetch(urlApi)
                .then((response) => {
                    return response.json();
                })
                .then((ranking_data) => {
                    //this.generar_rank(ranking_data);
                    console.log(ranking_data);

                    //check error
                    if (ranking_data.name == "error") this.retornar_error();

                    this.data_parti = ranking_data;
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
