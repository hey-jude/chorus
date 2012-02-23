describe("chorus.views.DatasetFilterWizard", function() {
    beforeEach(function() {
        this.dataset = fixtures.datasetSandboxTable();
        this.collection = this.dataset.columns().reset([fixtures.databaseColumn(), fixtures.databaseColumn()]);
        this.view = new chorus.views.DatasetFilterWizard({collection: this.collection});
    });

    describe("#render", function() {
        beforeEach(function() {
            this.view.render();
        });

        it("displays the filter title", function() {
            expect(this.view.$("h1.filter_title").text()).toMatchTranslation("dataset.filter.title");
        });

        it("displays one filter when rendered at first", function() {
            expect(this.view.$("li.dataset_filter").length).toBe(1);
        });

        it("adds the 'last' class to the only li", function() {
            expect(this.view.$("li.dataset_filter")).toHaveClass("last");
        });

        describe("#whereClause", function() {
            beforeEach(function() {
                spyOn(this.view.filterViews[0], "filterString").andReturn("foo = 1");
            });

            it("joins the individual filters' conditions", function() {
                expect(this.view.whereClause()).toBe("WHERE foo = 1");
            });

            describe("when all filterViews return an empty string", function() {
                beforeEach(function() {
                    this.view.filterViews[0].filterString.andReturn("");
                });

                it("returns an empty string (not 'WHERE ')", function() {
                    expect(this.view.whereClause()).toBe("");
                });
            });
        });

        describe("#filterCount", function() {
            beforeEach(function() {
                this.view.filterViews = [
                    {filterString: function() {return "foo = 2"}},
                    {filterString: function() {return ""}},
                    {filterString: function() {return "foo = 4"}}
                ]
            })

            it("eliminates empty filters", function() {
                expect(this.view.filterCount()).toBe(2);
            })
        })

        describe("removing the only filter", function() {
            beforeEach(function() {
                this.view.$(".remove").click();
            });

            describe("#whereClause", function() {
                it("returns an empty string", function() {
                    expect(this.view.whereClause()).toBe("");
                });
            });
        });

        describe("clicking the add filter link", function() {
            beforeEach(function() {
                this.view.$("a.add_filter").click();
            });

            it("adds another filter", function() {
                expect(this.view.$("li.dataset_filter").length).toBe(2);
            });

            it("adds the last class to the new filter and removes it from the old", function() {
                expect(this.view.$("li.dataset_filter:eq(0)")).not.toHaveClass("last");
                expect(this.view.$("li.dataset_filter:eq(1)")).toHaveClass("last");
            });

            describe("#whereClause", function() {
                beforeEach(function() {
                    spyOn(this.view.filterViews[0], "filterString").andReturn("foo = 1");
                    spyOn(this.view.filterViews[1], "filterString").andReturn("bar = 2");
                });

                it("joins the individual filters' conditions", function() {
                    expect(this.view.whereClause()).toBe("WHERE foo = 1 AND bar = 2");
                });
            });

            describe("resetting the wizard", function() {
                it("resets back to the default filter", function() {
                    this.view.resetFilters();
                    expect(this.view.$('li.dataset_filter').length).toBe(1);
                })
            });

            describe("removing the filter", function() {
                beforeEach(function() {
                    this.oldView = this.view.filterViews[1];
                    this.view.$(".remove:eq(1)").click();
                });

                it("removes the filterView from the DOM", function() {
                    expect(this.view.$("li.dataset_filter").length).toBe(1);
                });

                it("adds the 'last' class to the only li", function() {
                    expect(this.view.$("li.dataset_filter")).toHaveClass("last");
                });

                it("removes the filterView from the view's filterViews collection", function() {
                    expect(this.view.filterViews.length).toBe(1);
                    expect(this.view.filterViews[0]).not.toBe(this.oldView);
                });
            });
        });
    });

    describe("#removeInvalidFilters", function() {
        beforeEach(function() {
            this.view.render();
            this.view.addFilter();
            this.selectedColumn = this.collection.at(0);
            this.view.filterViews[1].columnFilter.$('options[data-cid=' + this.selectedColumn.cid + ']').prop('selected', true);
            this.view.filterViews[1].columnFilter.$('select').change();
            this.collection.remove(this.selectedColumn);
        })

        it("removes the invalid filter", function() {
            expect(this.view.filterViews.length).toBe(1);
            expect(this.view.$('.column_filter select').get(0).selectedIndex).toBe(0);
        })
    })
});