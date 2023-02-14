<template>
    <div class="write-comment form">
        <div class="header">Write Comment</div>
        <div class="body">
            <form @submit.prevent="onWriteComment" method="post" action="">
                <div class="field">
                    <div class="name">
                        <label for="text">Text</label>
                    </div>
                    <div class="value">
                        <textarea id="text" name="text" v-model="text"></textarea>
                    </div>
                </div>
                <div class="error">{{ error }}</div>
                <div class="button-field">
                    <input type="submit" value="Write">
                </div>
            </form>
        </div>
    </div>
</template>

<script>
export default {
    name: "WriteComment",
    data: function () {
        return {
            text: "",
            error: ""
        };
    },
    props: ["post"],
    methods: {
        onWriteComment: function () {
            this.error = "";
            this.$root.$emit("onWriteComment", this.post.id, this.text);
        }
    },
}
</script>

<style scoped>
.write-comment {
    margin-bottom: 20px;
}

.write-comment .field textarea {
    min-height: 8rem;
}
</style>