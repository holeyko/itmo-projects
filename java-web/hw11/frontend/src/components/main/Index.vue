<template>
    <div class="posts">
        <Post v-for="post in sortedPost" :post="post" :key="post.id"/>
    </div>
</template>

<script>

import Post from "@/components/domain/Post.vue";

export default {
    name: "Index",
    components: {
        Post
    },
    props: ["posts"],
    computed: {
        sortedPost: function () {
            return Object.values(this.posts).sort((a, b) => b.id - a.id);
        }
    },
}
</script>

<style scoped>

</style>
