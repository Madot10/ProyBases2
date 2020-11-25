<template>
    <b-container>
        <b-row class="vh-100" align-v="center">
            <b-col col></b-col>
            <b-col col>
                <BtnMenu title="REPORTES" nameUrl="Reportes"></BtnMenu>
                <BtnMenu title="SIMULACIÓN" nameUrl="Simulacion"></BtnMenu>
            </b-col>
            <b-col col></b-col>
        </b-row>
    </b-container>
</template>

<script>
import BtnMenu from "../components/BtnMenu.vue";

export default {
    components: { BtnMenu },
    data() {
        return {};
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
