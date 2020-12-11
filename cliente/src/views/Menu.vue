<template>
    <b-container>
        <b-row class="vh-100" align-v="center">
            <b-col col></b-col>
            <b-col col>
                <h1 class="text-center text-white">Le Mans</h1>

                <BtnMenu title="REPORTES" nameUrl="Reportes"></BtnMenu>
                <BtnMenu title="SIMULACIÓN" @click="abrir_modal_sim()"></BtnMenu>
                <ModalOpcionesSim></ModalOpcionesSim>
            </b-col>
            <b-col col></b-col>
        </b-row>
    </b-container>
</template>

<script>
import BtnMenu from "../components/BtnMenu.vue";
import ModalOpcionesSim from "../components/ModalOpcionesSim.vue";

export default {
    components: { BtnMenu, ModalOpcionesSim },
    data() {
        return {};

        ModalOpcionesSim;
    },
    methods: {
        abrir_modal_sim() {
            this.$bvModal.show("modal-sim");
        },
    },
};
</script>

<style>
body {
    background-image: url("~@/assets/fondo_menu.png");

    background-repeat: no-repeat;
    background-attachment: fixed;
    background-size: cover;
    background-position: 40% 0;
}
</style>
