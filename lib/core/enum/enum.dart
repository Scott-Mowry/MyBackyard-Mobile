enum UserRoleEnum { User, Business, Admin }

enum RequestTypeEnum { GET, POST, DELETE, PUT, PATCH }

enum ImageTypeEnum { asset, file, network }

enum SubscriptionTypeEnum {
  user_sub('1'),
  bus_sub_monthly('2'),
  bus_sub_annually('3'),
  bus_basic('4');

  const SubscriptionTypeEnum(this.id);

  final String id;
}
