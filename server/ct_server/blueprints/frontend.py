from flask import Blueprint, render_template, flash, request
from sqlalchemy.exc import OperationalError
from flask_paginate import Pagination, get_page_parameter

from ct_server.models import Exposure
EXPOSURES_PER_PAGE = 10

exposures = Blueprint("exposures", __name__)


@exposures.route("/")
def index():
    search = False
    q = request.args.get("q")
    if q:
        search = True
    page = request.args.get(get_page_parameter(), type=int, default=1)

    try:
        all_expos = Exposure.query.order_by(
            Exposure.timestamp.desc()
        )
        expos = all_expos.paginate(page, per_page=EXPOSURES_PER_PAGE)
        pagination = Pagination(page=page, total=all_expos.count(), search=search, record_ame="exposures",
                                bs_version=4)
    except OperationalError:
        flash("No exposures in the database.")
        all_expos = None

    return render_template(
        "exposures.html",
        expo_list=expos,
        pagination=pagination
    )
