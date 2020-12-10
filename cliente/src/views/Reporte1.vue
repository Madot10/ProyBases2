<template>
    <ScreenWindow>
        <b-container class="h-100">
            <b-row class="h-100" align-v="center">
                <CardRaking></CardRaking>
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
        obtener_datos() {
            let urlApi = `http://localhost:3000/ranking_anno/${this.$route.params.anno_sel}/${this.$route.params.cat_sel}/${this.$route.params.event_sel}`;

            //Solicitamos datos
            fetch(urlApi)
                .then((response) => {
                    return response.json();
                })
                .then((ranking_data) => {
                    this.datos_rank = ranking_data;
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
