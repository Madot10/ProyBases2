<template>
    <b-modal id="modal-reportes" hide-footer centered title="Parámetros de reporte">
        <!-- SELECCIONAR AÑO -->
        <b-form-group label="Selecciona un año" label-for="input-1">
            <b-form-select
                id="input-1"
                v-model="aux_anno_selected"
                :options="reporte == 3 ? annos_null : annos"
            ></b-form-select>
        </b-form-group>

        <!-- SELECCIONAR CATEGORIA -->
        <transition name="fade">
            <b-form-group
                label="Selecciona un categoría"
                label-for="input-2"
                v-show="aux_anno_selected != null"
            >
                <b-form-select
                    id="input-2"
                    v-model="aux_cat_selected"
                    :options="cats_filtered"
                ></b-form-select>
            </b-form-group>
        </transition>

        <!-- SELECCIONAR Tipo de evento (reporte 1) -->
        <transition name="fade">
            <b-form-group
                label="Selecciona el tipo de evento para ordenar"
                label-for="input-3"
                v-show="aux_anno_selected != null && reporte == 1"
            >
                <b-form-select
                    id="input-3"
                    v-model="aux_tipo_selected"
                    :options="tipos_eventos"
                ></b-form-select>
            </b-form-group>
        </transition>

        <!-- SELECCIONAR Hora (reporte 2) -->
        <transition name="fade">
            <b-form-group
                label="Selecciona hora"
                label-for="input-4"
                v-show="aux_anno_selected != null && reporte == 2"
            >
                <b-form-select
                    id="input-4"
                    v-model="aux_hora_selected"
                    :options="horas"
                ></b-form-select>
            </b-form-group>
        </transition>

        <p
            class="text-danger"
            v-show="
                (reporte == 1 &&
                    (aux_anno_selected == null ||
                        aux_cat_selected == null ||
                        aux_tipo_selected == null)) ||
                    (reporte == 2 &&
                        (aux_anno_selected == null ||
                            aux_hora_selected == null ||
                            aux_cat_selected == null)) ||
                    (reporte == 3 && (aux_anno_selected == null || aux_cat_selected == null))
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
    //Reporte 1,2 o 3
    props: ["reporte"],
    data() {
        return {
            annos: [2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009],
            annos_null: [
                { text: "Década", value: "d" },
                2000,
                2001,
                2002,
                2003,
                2004,
                2005,
                2006,
                2007,
                2008,
                2009,
            ],
            cats: [
                { anno: [2000, 2001, 2002, 2003, 2004, 2005], value: "LMP 900", text: "LMP 900" },
                { anno: [2000, 2001, 2002, 2003, 2004], value: "LM P675", text: "LM P675" },
                { anno: [2000, 2001, 2002, 2003, 2004, 2005, 2006], value: "LM GT", text: "LM GT" },
                {
                    anno: [2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007],
                    value: "LM GTS",
                    text: "LM GTS",
                },
                { anno: [2001, 2002, 2003], value: "LM GTP", text: "LM GTP" },
                { anno: [2004, 2005, 2006, 2007, 2008, 2009], value: "LM P2", text: "LM P2" },
                { anno: [2004, 2005, 2006, 2007, 2008, 2009], value: "LM P1", text: "LM P1" },
                { anno: [2005, 2006, 2007, 2008, 2009], value: "LM GT1", text: "LM GT1" },
                { anno: [2005, 2006, 2007, 2008, 2009], value: "LM GT2", text: "LM GT2" },
            ],
            cats_filtered: [],
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
            horas: [
                1,
                2,
                3,
                4,
                5,
                6,
                7,
                8,
                9,
                10,
                11,
                12,
                13,
                14,
                15,
                16,
                17,
                18,
                19,
                20,
                21,
                22,
                23,
                24,
            ],

            //auxiliares opciones marcadas
            aux_anno_selected: null,
            aux_cat_selected: null,
            aux_tipo_selected: null,
            aux_hora_selected: null,
        };
    },
    methods: {
        //Comprobar condiciones campos obligatorios
        comprobar_selecciones() {
            if (
                this.reporte == 1 &&
                this.aux_anno_selected != null &&
                this.aux_cat_selected != null &&
                this.aux_tipo_selected != null
            ) {
                return true;
            } else if (
                this.reporte == 2 &&
                this.aux_anno_selected != null &&
                this.aux_hora_selected != null &&
                this.aux_cat_selected != null
            ) {
                return true;
            } else if (
                this.reporte == 3 &&
                this.aux_anno_selected != null &&
                this.aux_cat_selected != null
            ) {
                return true;
            } else {
                return false;
            }
        },
        enviar_parametros() {
            if (this.comprobar_selecciones()) {
                //Todo bien
                switch (this.reporte) {
                    case 1:
                        this.$router.push({
                            name: "Reporte 1",
                            params: {
                                anno_sel: this.aux_anno_selected,
                                cat_sel: this.aux_cat_selected,
                                event_sel: this.aux_tipo_selected,
                            },
                        });
                        break;
                    case 2:
                        this.$router.push({
                            name: "Reporte 2",
                            params: {
                                anno_sel: this.aux_anno_selected,
                                cat_sel: this.aux_cat_selected,
                                hora_sel: this.aux_hora_selected,
                            },
                        });
                        break;

                    default:
                        alert("¡Ha ocurrido un error! Francia se ha rendido en la guerra");
                        break;
                }
            }
        },
    },
    watch: {
        //Segun año, devolvemos categorias existentes
        aux_anno_selected(anno_sel) {
            if (anno_sel != "d") {
                this.aux_cat_selected = null;
                this.cats_filtered = this.cats.filter((cat) => {
                    return cat.anno.includes(anno_sel);
                });
            } else {
                //Toda la decada
                this.cats_filtered = this.cats;
            }
        },
    },
};
</script>

<style></style>
