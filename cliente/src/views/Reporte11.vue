<template>
    <ScreenWindow>
        <b-container class="h-100 ">
            <b-row class="h-100" align-v="center">
                <h3 class="text-center mb-2 w-100">
                    Velocidades medias más altas
                </h3>

                <div v-for="(parti, i) in data_parti" :key="i" class="w-100">
                    <b-container>
                        <b-row align-v="center">
                            <b-col cols="5">
                                <!-- IMG VEHICULO -->
                                <b-img
                                    rounded
                                    :src="check_base64(parti.imgvehiculo)"
                                    fluid-grow
                                ></b-img>
                            </b-col>
                            <b-col cols="6">
                                <!-- Nro equipo, Nombre y bandera de nac -->
                                <h3>
                                    {{ parti.nroequipo }} - {{ parti.nombreequipo }}
                                    <b-img
                                        id="img-pais"
                                        rounded
                                        :src="check_base64(parti.imgbanderaequipo)"
                                    ></b-img>
                                </h3>
                                <!-- ANO DE PARTICIPACION -->
                                <p>
                                    <b>AÑO DE PARTICIPACIÓN: {{ parti.anno }}</b>
                                </p>
                                <!--Modelo Veh-->
                                <p>{{ parti.modelo }}</p>
                                <!--Modelo Veh-->
                                <p>Vel. media registrada: {{ parti.velmedia }} km/h</p>
                            </b-col>
                        </b-row>
                    </b-container>
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
            data_parti: [],
            is_loading: true,
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
        //check base64 encabezado
        check_base64(b64) {
            if (b64 && !b64.includes("data:image")) {
                return "data:image/jpeg;base64," + b64;
            } else if (b64) {
                return b64;
            } else {
                return null;
            }
        },
        //Obtener datos desde el MBD
        obtener_datos() {
            let urlApi = `http://localhost:3000/mejores_vel/${this.$route.params.ord_sel}/${this.$route.params.anno_sel}`;

            //Solicitamos datos
            fetch(urlApi)
                .then((response) => {
                    return response.json();
                })
                .then((ranking_data) => {
                    //this.generar_rank(ranking_data);

                    //check error
                    if (ranking_data.name == "error") this.retornar_error();

                    console.log(ranking_data);
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

<style>
#img-pais {
    max-width: 30px;
}
</style>
