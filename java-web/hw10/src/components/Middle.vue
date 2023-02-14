<template>
    <div class="middle">
        <Sidebar :posts="viewPosts"/>
        <main>
            <Index :users="users" :posts="posts" :comments="comments" v-if="page === 'Index'"/>
            <Enter v-if="page === 'Enter'"/>
            <Register v-if="page === 'Register'"/>
            <WritePost v-if="page === 'WritePost'"/>
            <EditPost v-if="page === 'EditPost'"/>
            <Users :users="users" v-if="page === 'Users'"/>
            <FullPost :users="users" :post="posts[postId]" :comments="postComments(postId)" v-if="page === 'FullPost'"/>
        </main>
    </div>
</template>

<script>
import Sidebar from "@/components/sidebar/Sidebar";
import Index from "@/components/page/Index";
import Enter from "@/components/page/Enter";
import WritePost from "@/components/page/WritePost";
import EditPost from "@/components/page/EditPost";
import Register from "@/components/page/Register";
import Users from "@/components/page/Users";
import FullPost from "@/components/page/FullPost.vue";

export default {
    name: "Middle",
    data: function () {
        return {
            page: "Index",
            postId: null,
        }
    },
    components: {
        FullPost,
        Users,
        Register,
        WritePost,
        Enter,
        Index,
        Sidebar,
        EditPost
    },
    props: ["posts", "users", "comments"],
    computed: {
        viewPosts: function () {
            return Object.values(this.posts).sort((a, b) => b.id - a.id).slice(0, 2);
        }
    }, beforeCreate() {
        this.$root.$on("onChangePage", (page) => this.page = page);
        this.$root.$on("onViewPost", (id) => {
            this.postId = id;
            this.$root.$emit("onChangePage", "FullPost");
        })
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
