class ResponseData<T> {
  Status status;
  T? data;
  String? message;



  ResponseData.loading(this.message) : status = Status.Loading;

  ResponseData.success(this.data) : status = Status.Success;

  ResponseData.error(this.message) : status = Status.Error;

  ResponseData.connectivityError() : status = Status.ConnectivityError;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { Loading, Success, Error, ConnectivityError }