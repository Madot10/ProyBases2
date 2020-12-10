<template>
    <ScreenWindow>
        <b-container class="h-100">
            <b-row class="h-100" align-v="center">
                <div v-for="(parti, i) in datos_rank" :key="i">
                    <CardRaking :datos="parti" :tipo_event="$route.params.event_sel"></CardRaking>
                    <br />
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
        };
    },
    methods: {
        //Generar array agrupados
        generar_rank(datos) {
            let aux_rank = [];
            let aux_arr = [];

            //Agrupemos pilotos
            datos.forEach((c, i) => {
                //Si no existe registro de equipo
                if (aux_rank[c.nroequipo] == null) {
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
                    //Tenemos guardado
                    datos[aux_rank[c.nroequipo]].pilotos.push({
                        gentilicio: c.gentilicio,
                        imgbanderapiloto: c.imgbanderapiloto,
                        imgpiloto: c.imgpiloto,
                        nombrepiloto: c.nombrepiloto,
                    });
                }
            });
            this.datos_rank = aux_arr;
        },
        //Obtener datos desde el MBD
        obtener_datos() {
            let urlApi = `http://localhost:3000/ranking_anno/${this.$route.params.anno_sel}/${this.$route.params.cat_sel}/${this.$route.params.event_sel}`;

            //Solicitamos datos
            fetch(urlApi)
                .then((response) => {
                    return response.json();
                })
                .then((ranking_data) => {
                    this.generar_rank(ranking_data);
                    console.log("DATOS OBTENIDOS", ranking_data);
                });
        },
    },
    created() {
        this.obtener_datos();
    },
};
</script>

<style></style>
