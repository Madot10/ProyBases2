<template>
    <ScreenWindow>
        <b-container class="h-100 ">
            <b-row class="h-100" align-v="center">
                <h3 class="text-center mb-2 w-100">
                    >Ranking hora - {{ $route.params.anno_sel }} - {{ $route.params.hora_sel }}h
                </h3>

                <div v-for="(parti, i) in datos_rank" :key="i">
                    <CardRaking
                        :datos="parti"
                        :hora="$route.params.hora_sel"
                        :limites="limites"
                        tipo_event="car"
                    ></CardRaking>
                    <br />
                </div>
                <!-- MENSAJE - DATOS VACIOS -->
                <div
                    v-show="datos_rank.length == 0 && is_loading == false"
                    class="mt-2 text-center mx-auto"
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
import CardRaking from "../components/CardRanking.vue";

export default {
    components: { ScreenWindow, CardRaking },
    data() {
        return {
            datos_rank: [],
            limites: {
                nro_v: 0,
                km: 0,
                vel_media: 0,
                dif_v: 0,
            },
            is_loading: true,
        };
    },
    methods: {
        //Guardar mayor valor
        guardar_valor_alto(valor, tipo) {
            if (this.limites[tipo] < Number(valor)) {
                //guardamos nuevo
                this.limites[tipo] = Number(valor);
            }
        },
        //Generar array agrupados
        generar_rank(datos) {
            let aux_rank = [];
            //Array nuevo de datos
            let aux_arr = [];

            //Agrupemos por pilotos
            datos.forEach((c, i) => {
                //Verificamos valores de limites
                this.guardar_valor_alto(c.nrovueltascarrera, "nro_v");
                this.guardar_valor_alto(c.distrecorrida, "km");
                this.guardar_valor_alto(c.velmediacarrera, "vel_media");
                this.guardar_valor_alto(c.difvueltas, "dif_v");

                //Si no existe registro de equipo
                if (aux_rank[c.nroequipo] == null) {
                    //Guardamos index de array original
                    aux_rank[c.nroequipo] = i;

                    c.pilotos = [];

                    c.pilotos.push({
                        gentilicio: c.gentilicio,
                        imgbanderapiloto: c.imgbanderapiloto,
                        imgpiloto: c.imgpiloto,
                        nombrepiloto: c.nombrepiloto,
                    });

                    aux_arr.push(c);
                } else {
                    //Tenemos registro, guardamos
                    if (datos[aux_rank[c.nroequipo]].pilotos.length < 3)
                        datos[aux_rank[c.nroequipo]].pilotos.push({
                            gentilicio: c.gentilicio,
                            imgbanderapiloto: c.imgbanderapiloto,
                            imgpiloto: c.imgpiloto,
                            nombrepiloto: c.nombrepiloto,
                        });
                }
            });
            //Guardamos
            this.datos_rank = aux_arr;
            this.is_loading = false;
        },
        //Obtener datos desde el MBD
        obtener_datos() {
            let urlApi = `http://localhost:3000/ranking_hora/${this.$route.params.anno_sel}/${this.$route.params.cat_sel}/${this.$route.params.hora_sel}`;

            //Solicitamos datos
            fetch(urlApi)
                .then((response) => {
                    return response.json();
                })
                .then((ranking_data) => {
                    this.generar_rank(ranking_data);
                    console.log("DATOS OBTENIDOS", ranking_data);
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
