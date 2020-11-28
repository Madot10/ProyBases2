<template>
    <div id="app">
        <transition name="fade">
            <router-view />
        </transition>
    </div>
</template>

<style>
.fade-enter-active,
.fade-leave-active {
    transition-duration: 250ms;
    transition-property: opacity;
    transition-timing-function: ease;
}

.fade-enter,
.fade-leave-active {
    opacity: 0;
}
</style>
