<template>
    <b-modal id="modal-new-reportes" hide-footer centered title="Parámetros de reporte">
        <!-- SELECCIONAR AÑO -->
        <b-form-group label="Selecciona un año" label-for="input-1" v-show="reporte == 4">
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

        <p
            class="text-danger"
            v-show="(reporte == 5 || reporte == 16) && aux_piloto_selected == null"
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

            aux_anno_selected: null,
            aux_nro_team_selected: null,
            aux_piloto_selected: null,
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
                //Reporte 5
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
            }
        },
        validar_select() {
            switch (this.reporte) {
                case 16:
                case 5:
                    if (this.aux_piloto_selected == false) {
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
