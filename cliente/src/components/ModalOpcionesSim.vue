<template>
    <b-modal id="modal-sim" hide-footer centered title="Parámetros de simulación">
        <!-- SELECCIONAR Anno de ref -->
        <b-form-group
            label="Selecciona un año de referencia"
            description="Será utilizado para seleccionar los competidores"
            label-for="input-1"
        >
            <b-form-select
                id="input-1"
                v-model="aux_anno_selected"
                :options="annos_opciones"
            ></b-form-select>
        </b-form-group>

        <!-- SELECCIONAR PISTA -->
        <b-form-group label="Selecciona una pista" label-for="input-2">
            <b-form-select
                id="input-2"
                v-model="aux_pista_selected"
                :options="pista_opciones"
            ></b-form-select>
        </b-form-group>

        <!-- SELECCIONAR CLIMA -->
        <b-form-group
            label="Selecciona un clima inicial"
            description="Será el clima de la primera hora"
            label-for="input-3"
        >
            <b-form-select
                id="input-3"
                v-model="aux_clima_selected"
                :options="clima_opciones"
            ></b-form-select>
        </b-form-group>

        <!-- FOOTER  -->
        <p
            class="text-danger"
            v-show="
                aux_pista_selected == null ||
                    aux_anno_selected == null ||
                    aux_clima_selected == null
            "
        >
            *Debes seleccionar los parámetros
        </p>
        <b-button block pill variant="outline-primary" @click="enviar_parametros()">
            INICIAR SIMULACIÓN
        </b-button>
    </b-modal>
</template>

<script>
export default {
    data() {
        return {
            //Opciones
            pista_opciones: [
                { text: "Pista 1 - 13.605 km", value: 1 },
                { text: "Pista 2 - 13.650 km", value: 2 },
                { text: "Pista 3 - 13.629 km", value: 3 },
            ],
            annos_opciones: [2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009],
            clima_opciones: [
                { text: "Despejado", value: "d" },
                { text: "Nublado", value: "n" },
                { text: "Lluvioso", value: "ll" },
            ],

            //Selecciones
            aux_pista_selected: null,
            aux_anno_selected: null,
            aux_clima_selected: null,
        };
    },
    methods: {
        comprobar_seleccion() {
            if (
                this.aux_pista_selected == null ||
                this.aux_anno_selected == null ||
                this.aux_clima_selected == null
            ) {
                return false;
            } else {
                return true;
            }
        },
        enviar_parametros() {
            if (this.comprobar_seleccion()) {
                this.$router.push({
                    name: "Simulacion",
                    params: {
                        anno_ref: this.aux_anno_selected,
                        pista: this.aux_pista_selected,
                        clima: this.aux_clima_selected,
                    },
                });
            }
        },
    },
};
</script>

<style></style>
