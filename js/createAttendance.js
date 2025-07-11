function toggleSidebar() {
   document.getElementById("sidebar").classList.toggle("show");
 }

 function handleAttendanceStatusChange() {
   const status = document.getElementById("attendanceStatus").value;
   const checkinTime = document.getElementById("checkinTime");
   const checkoutTime = document.getElementById("checkoutTime");
   const checkinTemp = document.getElementById("checkinTemp");
   const isAbsent = status === "Absent";

   checkinTime.disabled = isAbsent;
   checkoutTime.disabled = isAbsent;
   checkinTemp.disabled = isAbsent;

   if (isAbsent) {
     checkinTime.value = "";
     checkoutTime.value = "";
     checkinTemp.value = "";
   }
 }

 document.addEventListener("DOMContentLoaded", function () {
   const statusDropdown = document.getElementById("attendanceStatus");
   if (statusDropdown) {
     statusDropdown.addEventListener("change", handleAttendanceStatusChange);
   }
 });