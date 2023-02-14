<template>
    <div class="full-post">
        <Post :users="users" :commentsCount="comments.length" :post="post"/>
        <WriteComment :post="post" v-if="userId"/>
        <Comment v-for="comment in comments" :users="users" :comment="comment" :key="comment.id"/>
    </div>
</template>

<script>
import Post from "@/components/page/Post.vue";
import Comment from "@/components/page/Comment.vue";
import WriteComment from "@/components/page/WriteComment.vue";

export default {
    name: "PostPage",
    components: {WriteComment, Comment, Post},
    props: ["post", "comments", "users"]
}
</script>

<style scoped>

</style>