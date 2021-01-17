<template>
    <ScreenWindow>
        <b-container class="h-100 ">
            <b-row class="h-100" align-v="center">
                <h3 class="text-center mb-2 w-100">
                    Distancias más largas recorridas en Le Mans
                </h3>

                <div v-for="(parti, i) in datos_rank" :key="i">
                    <CardRaking :datos="parti" :limites="limites" tipo_event="car"></CardRaking>
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
        //Guardar mayor valor
        guardar_valor_alto(valor, tipo) {
            if (this.limites[tipo] < Number(valor) + 1) {
                //guardamos nuevo
                this.limites[tipo] = Number(valor) + 1;
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
                let c_anno = new Date(c.fechaevento);
                //console.log(c);
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
            let urlApi = `http://localhost:3000/mejores_dist/${this.$route.params.limit_sel}`;

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
