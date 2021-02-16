<template>
    <b-modal id="modal-new-reportes" hide-footer centered title="Parámetros de reporte">
        <!-- SELECCIONAR AÑO -->
        <b-form-group
            label="Selecciona un año"
            label-for="input-1"
            v-show="
                reporte == 4 ||
                    reporte == 7 ||
                    reporte == 8 ||
                    reporte == 10 ||
                    reporte == 11 ||
                    reporte == 16
            "
        >
            <b-form-select
                id="input-1"
                v-model="aux_anno_selected"
                :options="annos"
            ></b-form-select>
        </b-form-group>

        <!-- SELECCIONAR UN EQUIPO -->
        <b-form-group label="Selecciona un Nro. Equipo" label-for="input-2" v-show="reporte == 4">
            <b-form-select
                id="input-2"
                v-model="aux_nro_team_selected"
                :options="nros_teams"
            ></b-form-select>
        </b-form-group>

        <!-- SELECCIONAR UN PILOTO -->
        <b-form-group label="Selecciona un piloto" label-for="input-3" v-show="reporte == 5">
            <b-form-select
                id="input-3"
                v-model="aux_piloto_selected"
                :options="pilotos"
            ></b-form-select>
        </b-form-group>

        <!-- SELECCIONAR UN FABRICANTE -->
        <b-form-group label="Selecciona un fabricante" label-for="input-4" v-show="reporte == 6">
            <b-form-select
                id="input-4"
                v-model="aux_fab_auto_selected"
                :options="fab_auto"
            ></b-form-select>
        </b-form-group>

        <!-- SELECCIONAR UN MODELO AUTO -->
        <b-form-group label="Selecciona un modelo" label-for="input-5" v-show="reporte == 6">
            <b-form-select
                id="input-5"
                v-model="aux_model_auto_selected"
                :options="model_auto"
            ></b-form-select>
        </b-form-group>

        <!-- SELECCIONAR UN TIPO DE EVENTO -->
        <b-form-group
            label="Selecciona un tipo de evento"
            label-for="input-6"
            v-show="reporte == 11"
        >
            <b-form-select
                id="input-5"
                v-model="aux_tipo_evnt_selected"
                :options="tipos_eventos"
            ></b-form-select>
        </b-form-group>

        <!-- SELECCIONAR CANT LIMITE -->
        <b-form-group
            label="Selecciona cantidad limite de autos"
            label-for="input-6"
            v-show="reporte == 12"
        >
            <b-form-select
                id="input-5"
                v-model="aux_limit_selected"
                :options="limite_resultados"
            ></b-form-select>
        </b-form-group>

        <!-- SELECCIONAR TIPO DE FAB-->
        <b-form-group label="Selecciona un tipo" label-for="input-6" v-show="reporte == 15">
            <b-form-select
                id="input-6"
                v-model="aux_tip_fab_selected"
                :options="tipo_fab"
            ></b-form-select>
        </b-form-group>

        <p
            class="text-danger"
            v-show="
                (reporte == 5 && aux_piloto_selected == null) ||
                    ((reporte == 7 ||
                        reporte == 8 ||
                        reporte == 10 ||
                        reporte == 11 ||
                        reporte == 16) &&
                        aux_anno_selected == null) ||
                    (reporte == 11 && aux_tipo_evnt_selected == null) ||
                    (reporte == 12 && aux_limit_selected == null) ||
                    (reporte == 15 && aux_tip_fab_selected == null)
            "
        >
            *Debes seleccionar los parámetros
        </p>

        <!-- FOOTER  -->
        <b-button block pill variant="outline-primary" @click="enviar_parametros()">
            GENERAR REPORTE
        </b-button>
    </b-modal>
</template>

<script>
export default {
    props: ["reporte"],
    data() {
        return {
            annos: [],
            nros_teams: [],
            pilotos: [],
            fab_auto: [],
            model_auto: [],
            tipos_eventos: [
                {
                    value: "eny",
                    text: "Ensayo",
                },
                {
                    value: "car",
                    text: "Carrera",
                },
            ],
            limite_resultados: [
                { value: 10, text: "10 autos" },
                { value: 20, text: "20 autos" },
                { value: 30, text: "30 autos" },
                { value: 40, text: "40 autos" },
                { value: 50, text: "50 autos" },
                { value: 60, text: "60 autos" },
            ],
            tipo_fab: [
                { value: true, text: "Marca de auto" },
                { value: false, text: "Marca de neumatico" },
            ],

            aux_anno_selected: null,
            aux_nro_team_selected: null,
            aux_piloto_selected: null,
            aux_fab_auto_selected: null,
            aux_model_auto_selected: null,
            aux_tipo_evnt_selected: null,
            aux_limit_selected: null,
            aux_tip_fab_selected: null,
        };
    },
    methods: {
        retornar_error() {
            this.$bvModal.hide("modal-new-reportes");
        },
        obtener_parametros() {
            if (this.reporte == 4) {
                //Reporte 4
                //Annos
                fetch("http://localhost:3000/param/annos")
                    .then((response) => {
                        return response.json();
                    })
                    .then((annos_data) => {
                        console.log(annos_data);
                        //check error
                        if (annos_data.name == "error") this.retornar_error();

                        this.annos = annos_data.map((a) => {
                            return {
                                value: a.anno,
                                text: a.anno,
                            };
                        });
                        this.annos.unshift({
                            value: 0,
                            text: "En cualquier año",
                        });
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
                //Nro Equipos
                fetch("http://localhost:3000/param/nro_equipo")
                    .then((response) => {
                        return response.json();
                    })
                    .then((nros_team_data) => {
                        console.log(nros_team_data);
                        //check error
                        if (nros_team_data.name == "error") this.retornar_error();

                        this.nros_teams = nros_team_data.map((nt) => {
                            return {
                                value: nt.nroequipo,
                                text: nt.nroequipo,
                            };
                        });
                        this.nros_teams.unshift({
                            value: 0,
                            text: "Cualquier equipo",
                        });
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
            } else if (this.reporte == 5) {
                //Reporte 5
                //Pilotos
                fetch("http://localhost:3000/param/pilotos")
                    .then((response) => {
                        return response.json();
                    })
                    .then((pilotos_data) => {
                        console.log(pilotos_data);
                        //check error
                        if (pilotos_data.name == "error") this.retornar_error();

                        this.pilotos = pilotos_data.map((p) => {
                            return {
                                value: p.idpiloto,
                                text: p.nombrepiloto,
                            };
                        });
                        this.pilotos.unshift({
                            value: null,
                            text: "Seleccione un piloto",
                        });
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
            } else if (this.reporte == 6) {
                //Reporte 6
                //Fabricantes
                fetch("http://localhost:3000/param/fab-auto")
                    .then((response) => {
                        return response.json();
                    })
                    .then((fab_data) => {
                        console.log(fab_data);
                        //check error
                        if (fab_data.name == "error") this.retornar_error();

                        this.fab_auto = fab_data.map((p) => {
                            return {
                                value: p.fabricanteauto,
                                text: p.fabricanteauto,
                            };
                        });
                        this.fab_auto.unshift({
                            value: "0",
                            text: "Cualquier fabricante",
                        });
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

                //Modelo auto
                fetch("http://localhost:3000/param/model-auto")
                    .then((response) => {
                        return response.json();
                    })
                    .then((model_data) => {
                        console.log(model_data);
                        //check error
                        if (model_data.name == "error") this.retornar_error();

                        this.model_auto = model_data.map((m) => {
                            return {
                                value: m.modelosauto,
                                text: m.modelosauto,
                            };
                        });
                        this.model_auto.unshift({
                            value: "0",
                            text: "Cualquier modelo",
                        });
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
            } else if (
                this.reporte == 7 ||
                this.reporte == 8 ||
                this.reporte == 10 ||
                this.reporte == 11 ||
                this.reporte == 16
            ) {
                //Annos
                fetch("http://localhost:3000/param/annos")
                    .then((response) => {
                        return response.json();
                    })
                    .then((annos_data) => {
                        console.log(annos_data);
                        //check error
                        if (annos_data.name == "error") this.retornar_error();

                        this.annos = annos_data.map((a) => {
                            return {
                                value: a.anno,
                                text: a.anno,
                            };
                        });
                        //if (!this.reporte == 16)
                        this.annos.unshift({
                            value: 0,
                            text: "Cada año",
                        });
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
            }
        },
        validar_select() {
            switch (this.reporte) {
                case 5:
                    if (this.aux_piloto_selected == null) {
                        return false;
                    } else {
                        return true;
                    }
                    break;
                case 6:
                    if (
                        this.aux_fab_auto_selected == null ||
                        this.aux_model_auto_selected == null
                    ) {
                        return false;
                    } else {
                        return true;
                    }
                    break;
                case 7:
                case 8:
                case 16:
                    if (
                        (this.reporte == 7 || this.reporte == 8 || this.reporte == 16) &&
                        this.aux_anno_selected == null
                    ) {
                        return false;
                    } else {
                        return true;
                    }
                    break;
                case 11:
                    if (this.reporte == 11 && this.aux_tipo_evnt_selected == null) {
                        return false;
                    } else {
                        return true;
                    }
                    break;
                case 12:
                    if (this.reporte == 12 && this.aux_limit_selected == null) {
                        return false;
                    } else {
                        return true;
                    }
                    break;
                case 15:
                    if (this.reporte == 15 && this.aux_tip_fab_selected == null) {
                        return false;
                    } else {
                        return true;
                    }
                    break;
                default:
                    return true;
                    break;
            }
        },
        enviar_parametros() {
            if (this.validar_select())
                switch (this.reporte) {
                    case 4:
                        this.$router.push({
                            name: "Reporte 4",
                            params: {
                                anno_sel: this.aux_anno_selected,
                                nro_sel: this.aux_nro_team_selected,
                            },
                        });
                        break;

                    case 5:
                        this.$router.push({
                            name: "Reporte 5",
                            params: {
                                pilot_sel: this.aux_piloto_selected,
                            },
                        });
                        break;
                    case 6:
                        this.$router.push({
                            name: "Reporte 6",
                            params: {
                                fab_sel: this.aux_fab_auto_selected,
                                model_sel: this.aux_model_auto_selected,
                            },
                        });
                        break;
                    case 7:
                        this.$router.push({
                            name: "Reporte 7y8",
                            params: {
                                v: "n",
                                anno_sel: this.aux_anno_selected,
                            },
                        });
                        break;
                    case 8:
                        this.$router.push({
                            name: "Reporte 7y8",
                            params: {
                                v: "o",
                                anno_sel: this.aux_anno_selected,
                            },
                        });
                        break;

                    case 10:
                        this.$router.push({
                            name: "Reporte 10",
                            params: {
                                anno_sel: this.aux_anno_selected,
                            },
                        });
                        break;

                    case 11:
                        this.$router.push({
                            name: "Reporte 11",
                            params: {
                                ord_sel: this.aux_tipo_evnt_selected,
                                anno_sel: this.aux_anno_selected,
                            },
                        });
                        break;

                    case 12:
                        this.$router.push({
                            name: "Reporte 12",
                            params: {
                                limit_sel: this.aux_limit_selected,
                            },
                        });
                        break;

                    case 15:
                        this.$router.push({
                            name: "Reporte 15",
                            params: {
                                isauto_sel: this.aux_tip_fab_selected,
                            },
                        });
                        break;
                    case 16:
                        this.$router.push({
                            name: "Reporte 16",
                            params: {
                                anno_sel: this.aux_anno_selected,
                            },
                        });
                    default:
                        break;
                }
        },
    },
    watch: {
        reporte(nro_r) {
            this.obtener_parametros();
        },
    },

    mounted() {
        //console.log("montado");
    },
};
</script>

<style></style>
