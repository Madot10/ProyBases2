<template>
    <b-link :to="{ name: nameUrl }" id="link-a">
        <div id="screen" class="mt-5 mb-5" :class="[title == 'REPORTES' ? 'report' : 'sim']">
            <div id="title">
                <h3 class="text-center">{{ title }}</h3>
            </div>
        </div>
    </b-link>
</template>

<script>
export default {
    name: "BtnMenu",
    props: ["nameUrl", "title"],
};
</script>

<style scoped>
div#screen {
    padding: 3em 2em;
    color: white;
    /*text-shadow: 0px 2px 0px black;*/

    border: 8px solid gray;
    border-radius: 5%;

    background-repeat: no-repeat;
    background-size: cover;
}

div#screen.report {
    background-image: url("~@/assets/fondo_reporte.png");
}

div#screen.sim {
    background-image: url("~@/assets/fondo_sim.png");
}

div#title {
    background-color: darkblue;
}

h3 {
    padding: 0 5px;
}

#link-a {
    text-decoration: none;
}
</style>
