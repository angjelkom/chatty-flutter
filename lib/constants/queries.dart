
const CONVERSATIONS = """
{
  conversations {
    _id
    users {
      name
      _id
      phoneNumber
      profilePhoto
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

const String MESSAGES = """
query Messages(\$id: ID!) {
  messages(id: \$id){
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

const PROFILE = """
{
  profile {
    name
    phoneNumber
    birthday
    gender
    _id
    profilePhoto
  }
}
""";

const String SEARCH = """
query Search(\$query: String!) {
  search(query: \$query){
    _id
    name
    phoneNumber
    profilePhoto
  }
}
""";