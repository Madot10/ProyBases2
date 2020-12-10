<template>
    <b-card>
        <b-row>
            <b-col>
                <!-- FOTO PILOTO -->
                <b-img rounded="circle" :src="datos.imgpiloto" fluid-grow></b-img>
            </b-col>
            <b-col class="text-center">
                <!-- Nombre y nac -->
                <h4>{{ datos.nombrepiloto }}</h4>
                <b-img
                    rounded
                    :src="'data:image/png;base64,' + datos.imgbanderapiloto"
                    v-b-tooltip.hover
                    :title="datos.gentilicio"
                ></b-img>
            </b-col>
        </b-row>
    </b-card>
</template>

<script>
export default {
    props: ["datos"],
};
</script>

<style></style>
