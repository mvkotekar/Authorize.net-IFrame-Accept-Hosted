using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplication1;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void btnGenerateToken_Click(object sender, EventArgs e)
    {
        string token = "";
        GetAnAcceptPaymentPage.Run("89FVdsGYb7f", "5Lr795D69RH9b7c7", 1000.12m, this, out token);
        txtToken.Text = token;
    }
}