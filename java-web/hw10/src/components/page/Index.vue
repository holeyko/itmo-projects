<template>
    <div class="posts">
        <Post v-for="post in sortedPost" :post="post" :users="users" :commentsCount="postComments(post.id).length" :key="post.id"/>
    </div>
</template>

<script>
import Post from "./Post.vue";

export default {
    name: "Index",
    components: {
        Post
    },
    props: ["posts", "users", "comments"],
    computed: {
        sortedPost: function () {
            return Object.values(this.posts).sort((a, b) => b.id - a.id);
        }
    },
    methods: {
        postComments: function (postId) {
            return Object.values(this.comments).filter(comment => comment.postId === postId);
        }
    }
}
</script>

<style scoped>

</style>
