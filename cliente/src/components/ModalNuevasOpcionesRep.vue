<template>
    <b-modal id="modal-new-reportes" hide-footer centered title="Parámetros de reporte">
        <!-- SELECCIONAR AÑO -->
        <b-form-group
            label="Selecciona un año"
            label-for="input-1"
            v-show="reporte == 4 || reporte == 7 || reporte == 8 || reporte == 10"
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
        <b-form-group
            label="Selecciona un piloto"
            label-for="input-3"
            v-show="reporte == 5 || reporte == 16"
        >
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

        <p
            class="text-danger"
            v-show="
                ((reporte == 5 || reporte == 16) && aux_piloto_selected == null) ||
                    ((reporte == 7 || reporte == 8 || reporte == 10) && aux_anno_selected == null)
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

            aux_anno_selected: null,
            aux_nro_team_selected: null,
            aux_piloto_selected: null,
            aux_fab_auto_selected: null,
            aux_model_auto_selected: null,
        };
    },
    methods: {
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
            } else if (this.reporte == 16) {
                //Reporte 16
                //Pilotos
                fetch("http://localhost:3000/param/pilotos-fem")
                    .then((response) => {
                        return response.json();
                    })
                    .then((pilotos_data) => {
                        console.log(pilotos_data);
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
            } else if (this.reporte == 7 || this.reporte == 8 || this.reporte == 10) {
                //Annos
                fetch("http://localhost:3000/param/annos")
                    .then((response) => {
                        return response.json();
                    })
                    .then((annos_data) => {
                        console.log(annos_data);
                        this.annos = annos_data.map((a) => {
                            return {
                                value: a.anno,
                                text: a.anno,
                            };
                        });
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
                case 16:
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
                    if (
                        (this.reporte == 7 || this.reporte == 8) &&
                        this.aux_anno_selected == null
                    ) {
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
                    case 16:
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
                        breaks;
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
