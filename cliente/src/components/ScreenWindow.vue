<template>
    <div class="container-m">
        <div class="row-m">
            <div class="float-left">
                <b-icon
                    class="clicker"
                    @click="$router.go(-1)"
                    icon="caret-left-fill"
                    variant="dark"
                ></b-icon>
            </div>
            <div class="float-right">
                <span class="dot" style="background:#ED594A;"></span>
                <span class="dot" style="background:#FDD800;"></span>
                <span class="dot" style="background:#5AC05A;"></span>
            </div>
        </div>

        <div class="content">
            <slot></slot>
        </div>
    </div>
</template>

<script>
export default {};
</script>

<style scoped>
.clicker {
    cursor: pointer;
    font-size: 1.75rem;
}

/* Browser window */
.container-m {
    border: 3px solid #f1f1f1;
    border-top-left-radius: 10px;
    border-top-right-radius: 10px;

    margin: 20px;
}

.row-m {
    padding: 10px;
    background: #f1f1f1;
    border-top-left-radius: 4px;
    border-top-right-radius: 4px;
}

.row-m:after {
    content: "";
    display: table;
    clear: both;
}

/* Dots */
.dot {
    margin-top: 4px;
    margin-left: 2px;
    height: 12px;
    width: 12px;
    background-color: #bbb;
    border-radius: 50%;
    display: inline-block;
}

/* "Window" Content */
.content {
    height: calc(100vh - 40px - 60px);
    background-color: white;
}
</style>
