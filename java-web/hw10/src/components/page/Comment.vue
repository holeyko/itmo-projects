<template>
    <article>
        <div class="information">By {{ users[comment.userId].login }}</div>
        <div class="body">{{ comment.text }}</div>
    </article>
</template>

<script>
export default {
    name: "Comment",
    props: ["comment", "users"],
    computed: {

    }
}
</script>

<style scoped>

</style>