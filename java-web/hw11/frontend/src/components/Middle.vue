<template>
    <div class="middle">
        <Sidebar :posts="viewPosts"/>
        <main>
            <Index :posts="posts" v-if="page === 'Index'"/>
            <Enter v-if="page === 'Enter'"/>
            <Register v-if="page === 'Register'"/>
            <Users :users="users" v-if="page === 'Users'"/>
            <WritePost v-if="page === 'WritePost'"/>
        </main>
    </div>
</template>

<script>
import Sidebar from "./sidebar/Sidebar";
import Index from "./main/Index";
import Enter from "./main/Enter";
import Register from "./main/Register";
import Users from "@/components/page/Users.vue";
import WritePost from "@/components/page/WritePost.vue";

import axios from "axios";

export default {
    name: "Middle",
    data: function () {
        return {
            page: "Index",
            users: [],
        }
    },
    components: {
        WritePost,
        Users,
        Register,
        Enter,
        Index,
        Sidebar
    },
    props: ["posts"],
    computed: {
        viewPosts: function () {
            return Object.values(this.posts).sort((a, b) => b.id - a.id).slice(0, 2);
        }
    },
    methods: {
        updateUsers: function () {
            axios.get("/api/1/users").then(response => {
                this.users = response.data;
            });
        }
    },
    beforeCreate() {
        this.$root.$on("onChangePage", (page) => this.page = page);
        this.$root.$on("onUpdateUsers", () => this.updateUsers());
    },
    beforeMount() {
        this.updateUsers();
        setInterval(() => {
            this.updateUsers();
        }, 3000);
    },
}
</script>

<style scoped>

</style>
