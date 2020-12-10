<template>
    <b-card>
        <b-row>
            <b-col>
                <!-- FOTO PILOTO -->
                <b-img rounded="circle" src="https://picsum.photos/100/100/" fluid-grow></b-img>
            </b-col>
            <b-col class="text-center">
                <!-- Nombre y nac -->
                <h4>{{ datos.nombrepiloto }}</h4>
                <b-img rounded src="https://picsum.photos/25/25/"></b-img>
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
