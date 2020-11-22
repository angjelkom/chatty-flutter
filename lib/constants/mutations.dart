
const LOGIN = """
  mutation Login(\$phoneNumber: String!, \$password: String!) {
    login(phoneNumber:\$phoneNumber, password: \$password){
      token
      userId
    }
  }
""";

const SIGNUP = """
  mutation Signup(\$phoneNumber: String!, \$password: String!, \$name: String!) {
    signup(phoneNumber:\$phoneNumber, password: \$password, name: \$name){
      token
      userId
    }
  }
""";

const SAVE_PROFILE = """
  mutation SaveProfile(\$phoneNumber: String, \$name: String, \$birthday: String, \$gender: String, \$profilePhoto: Upload) {
    saveProfile(phoneNumber: \$phoneNumber, name: \$name, birthday: \$birthday, gender: \$gender, profilePhoto: \$profilePhoto){
      name
      birthday
      gender
      phoneNumber
      profilePhoto
    }
  }
""";

const String DELETE_CONVERSATION = """
  mutation DeleteConversation(\$id: ID!) {
    deleteConversation(id:\$id){
      error
      success
    }
  }
""";

const String SEND_MESSAGE = """
  mutation SendMessage(\$content: String!, \$files: [ChattyFileUpload], \$conversation: ID!) {
    sendMessage(content:\$content, files:\$files, conversation: \$conversation){
      _id
      content
      files {
        file
        thumbnail
      }
      sender {
        _id
        name
      }
    }
  }
""";

const String LISTEN_MESSAGE = """
  subscription MessageSubscribe(\$id: ID!) {
    message(id: \$id){
      _id
      content
      files {
        file
        thumbnail
      }
      sender {
        name
        _id
      }
    }
  }
""";

const String LISTEN_CONVERSATION = """
  subscription ConversationSubscribe(\$id: ID!) {
    conversation(id: \$id){
      _id
      users {
        name
        _id
        phoneNumber
      }
      messages {
        _id
        content
        files {
          file
          thumbnail
        }
        sender {
          name
          _id
        }
      }
    }
  }
""";

const String LISTEN_DATA = """
  subscription DataSubscribe(\$id: ID!) {
    data(id: \$id){
      update
      message {
        _id
        content
        files {
          file
          thumbnail
        }
        sender {
          name
          _id
        }
      }
      conversation {
        _id
        users {
          name
          _id
          phoneNumber
        }
        messages {
          _id
          content
          files {
            file
            thumbnail
          }
          sender {
            name
            _id
          }
        }
      }
    }
  }
""";

const String ADD_CONVERSATION = """
  mutation AddConversation(\$users: [ID!]!) {
    addConversation(users:\$users){
      _id
      users {
        name
        _id
        phoneNumber
      }
      messages {
        _id
        content
        files {
          file
          thumbnail
        }
        sender {
          name
          _id
        }
      }
    }
  }
""";