// =============================================================================
// WHAT : Data shape of the coupon list returned by the server.
// NOTES: Used by the coupons screens.
// =============================================================================
// >>> START: CouponsListModel - helper class
class CouponsListModel {
    String status;
    String url;
    List<Detail> details;
    Pagination pagination;

    CouponsListModel({
        required this.status,
        required this.url,
        required this.details,
        required this.pagination,
    });

}
// <<< END: CouponsListModel - helper class

// >>> START: Detail - helper class
class Detail {
    int id;
    String name;
    String description;
    String code;
    int discount;
    int maxDiscount;
    int minRideAmount;
    int maxUse;
    int maxUseOfCoupon;
    DateTime startDate;
    DateTime endDate;
    int isGlobal;
    int status;
    int typeId;
    DateTime createdOn;
    DateTime updatedOn;
    int createUserId;
    int updateUserId;

    Detail({
        required this.id,
        required this.name,
        required this.description,
        required this.code,
        required this.discount,
        required this.maxDiscount,
        required this.minRideAmount,
        required this.maxUse,
        required this.maxUseOfCoupon,
        required this.startDate,
        required this.endDate,
        required this.isGlobal,
        required this.status,
        required this.typeId,
        required this.createdOn,
        required this.updatedOn,
        required this.createUserId,
        required this.updateUserId,
    });

}
// <<< END: Detail - helper class

// >>> START: Pagination - helper class
class Pagination {
    int totalPages;
    int currentPage;
    int perPage;
    int totalCount;

    Pagination({
        required this.totalPages,
        required this.currentPage,
        required this.perPage,
        required this.totalCount,
    });

}
// <<< END: Pagination - helper class
