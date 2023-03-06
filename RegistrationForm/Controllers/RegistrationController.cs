using RegistrationForm.Models;
using RegistrationForm.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace RegistrationForm.Controllers
{
    public class RegistrationController : Controller
    {
        IRegistration objregister;
        public RegistrationController()
        {
            objregister = new RRegistration();
        }
        // GET: Registration
       // [Route("/User")]
        public ActionResult Index()
        {
            List<User> userList = objregister.GetUserData(null).ToList();
            List<State> statelist = objregister.GetState(null).ToList();
            statelist.Insert(0, new State { StateName = "Select State" });
            ViewBag.StateList = statelist;
            return View(userList);
        }
        [HttpPost] 
        public ActionResult SaveUserData(User Modal)
        {
            int result = 0;
             if(ModelState.IsValid)
            {
                result = objregister.InsertUserData(Modal);
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        public ActionResult GetCity(string stateid)
        {
            try
            {
                if (stateid == "")
                {
                    return Json(new List<City>(), JsonRequestBehavior.AllowGet);
                }
                else
                {
                    var data = objregister.GetCity(Convert.ToInt32(stateid)).ToList();
                    return Json(data, JsonRequestBehavior.AllowGet);
                }

            }
            catch (Exception ex)
            {
                //Save Error
                return Json(new List<City>(), JsonRequestBehavior.AllowGet);
            }
        }
        [HttpPost]
        public ActionResult DeleteUser(int Id)
        {
            Response obj = new Response();
            try
            {
                obj = objregister.DeleteUser(Id);
                return Json(obj, JsonRequestBehavior.AllowGet);
            }
            catch (Exception Ex)
            {
                //Save Error 
                obj.Message = "Somthing Went Wrong";
                obj.status = 0;
                return Json(obj, JsonRequestBehavior.AllowGet);
            }
        }
    }
}