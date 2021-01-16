<template>
    <ScreenWindow>
        <b-container class="h-100 ">
            <b-row class="h-100" align-v="center">
                <h3 class="text-center mb-2 w-100">
                    Ranking por Nro. Equipo - {{ $route.params.anno_sel }}
                </h3>
                <div v-for="(parti, i) in datos_rank" :key="i">
                    <CardRaking :datos="parti" tipo_event="car" :limites="limites"></CardRaking>
                    <br />
                </div>
                <!-- MENSAJE - DATOS VACIOS -->

                <div
                    v-show="datos_rank.length == 0 && is_loading == false"
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
        //check base64 encabezado
        check_base64(b64) {
            if (!b64.includes("data:image")) {
                return "data:image/jpeg;base64," + b64;
            } else {
                return b64;
            }
        },
        //Generar array agrupados
        generar_rank(datos) {
            let aux_rank = [];
            //Array nuevo de datos
            let aux_arr = [];

            //Agrupemos por pilotos
            datos.forEach((c, i) => {
                //Si no existe registro de equipo
                //Verificamos valores de limites
                this.guardar_valor_alto(c.nrovueltascarrera, "nro_v");
                this.guardar_valor_alto(c.distrecorrida, "km");
                this.guardar_valor_alto(c.velmediacarrera, "vel_media");
                this.guardar_valor_alto(c.difvueltas, "dif_v");

                //Si no existe registro de equipo
                let c_anno = new Date(c.anno);

                if (aux_rank[c.nroequipo + c_anno.getFullYear()] == null) {
                    //Guardamos index de array original
                    aux_rank[c.nroequipo + c_anno.getFullYear()] = i;

                    c.pilotos = [];

                    c.pilotos.push({
                        gentilicio: c.gentilicio,
                        imgbanderapiloto: c.imgbanderapiloto,
                        imgpiloto: this.check_base64(c.imgpiloto),
                        nombrepiloto: c.nombrepiloto,
                    });

                    c.imgvehiculo = this.check_base64(c.imgvehiculo);

                    aux_arr.push(c);
                } else {
                    //Tenemos registro, guardamos
                    if (datos[aux_rank[c.nroequipo + c_anno.getFullYear()]].pilotos.length < 3)
                        datos[aux_rank[c.nroequipo + c_anno.getFullYear()]].pilotos.push({
                            gentilicio: c.gentilicio,
                            imgbanderapiloto: c.imgbanderapiloto,
                            imgpiloto: this.check_base64(c.imgpiloto),
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
            let urlApi = `http://localhost:3000/ranking_equipo/${this.$route.params.anno_sel}/${this.$route.params.nro_sel}`;

            //Solicitamos datos
            fetch(urlApi)
                .then((response) => {
                    return response.json();
                })
                .then((ranking_data) => {
                    this.generar_rank(ranking_data);
                    console.log(ranking_data);
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
