package ru.itmo.web.hw4.util;

import ru.itmo.web.hw4.model.Post;
import ru.itmo.web.hw4.model.User;

import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

public class DataUtil {
    private static final List<User> USERS = Arrays.asList(
            new User(1, "MikeMirzayanov", "Mike Mirzayanov", User.UserColor.BLUE),
            new User(6, "pashka", "Pavel Mavrin", User.UserColor.RED),
            new User(9, "geranazavr555", "Georgiy Nazarov", User.UserColor.GREEN),
            new User(11, "tourist", "Gennady Korotkevich", User.UserColor.GREEN)
    );

    private static final List<Post> POSTS = Arrays.asList(
            new Post(1, 1, "Heloo1", "a;sldfkjs;lfkjsa;flksdjaf;sldkfjas;lfksdjaf;alsdkfjasdl;fkjsdaf;laskjfd;lkfjas;lfkjasdf;lkasdjf;asdklfjsda;lfkjasd;flksdjf;lasdkjfsdl;kfjasd;lkfjasd;flkasdjf;lsdkjf;lasdkfjsdlk;fjas;lfkjsd"),
            new Post(2, 9, "Hello2", "a;sldfkjs;lfkjsa;flksdjaf;sldkfjas;lfksdjaf;alsdkfjasdl;fkjsdaf;laskjfd;lkfjas;lfkjasdf;lkasdjf;asdklfjsda;lfkjasd;flksdjf;lasdkjfsdl;kfjasd;lkfjasd;flkasdjf;lsdkjf;lasdkfjsdlk;fjas;lfkjsd"),
            new Post(5, 6, "Heloo3", "a;sldfkjs;lfkjsa;flksdjaf;sldkfjas;lfksdjaf;alsdkfjasdl;fkjsdaf;laskjfd;lkfjas;lfkjasdf;lkasdjf;asdklfjsda;lfkjasd;flksdjf;lasdkjfsdl;kfjasd;lkfjasd;flkasdjf;lsdkjf;lasdkfjsdlk;fjas;lfkjsd"),
            new Post(8, 11, "Heloo4", "a;sldfkjs;lfkjsa;flksdjaf;sldkfjas;lfksdjaf;alsdkfjasdl;fkjsdaf;laskjfd;lkfjas;lfkjasdf;lkasdjf;asdklfjsda;lfkjasd;flksdjf;lasdkjfsdl;kfjasd;lkfjasd;flkasdjf;lsdkjf;lasdkfjsdlk;fjas;lfkjsd"),
            new Post(12, 1, "Heloo5", "asl;kfdj asdlk;fj sd;lfkasjfkl;sdjaf;sd fksdjafl;sdjafklsdjafl;ksdj f;sdklafjsdlk;fjsa;lkfj sdak;fsdl;fkjsd;kflsda;dlkjalsdfkj asl;kfdj asdlk;fj sd;lfkasjfkl;sdjaf;sd fksdjafl;sdjafklsdjafl;ksdj f;sdklafjsdlk;fjsa;lkfj sdak;fsdl;fkjsd;kflsda;dlkjalsdfkj asl;kfdj asdlk;fj sd;lfkasjfkl;sdjaf;sd fksdjafl;sdjafklsdjafl;ksdj f;sdklafjsdlk;fjsa;lkfj sdak;fsdl;fkjsd;kflsda;dlkjalsdfkj asl;kfdj asdlk;fj sd;lfkasjfkl;sdjaf;sd fksdjafl;sdjafklsdjafl;ksdj f;sdklafjsdlk;fjsa;lkfj sdak;fsdl;fkjsd;kflsda;dlkjalsdfkj asl;kfdj asdlk;fj sd;lfkasjfkl;sdjaf;sd fksdjafl;sdjafklsdjafl;ksdj f;sdklafjsdlk;fjsa;lkfj sdak;fsdl;fkjsd;kflsda;dlkjalsdfkj")
    );

    public static void addData(HttpServletRequest request, Map<String, Object> data) {
        data.put("users", USERS);
        for (User user : USERS) {
            if ((Long) user.getId() == data.getOrDefault("logged_user_id", null)) {
                data.put("user", user);
            }
        }

        data.put("posts", POSTS);
    }
}
