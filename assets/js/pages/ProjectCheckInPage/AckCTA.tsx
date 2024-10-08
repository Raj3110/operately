import * as React from "react";
import * as ProjectCheckIns from "@/models/projectCheckIns";

import { PrimaryButton } from "@/components/Buttons";

import { useLoadedData, useRefresh } from "./loader";
import { useMe } from "@/contexts/CurrentUserContext";
import { compareIds } from "@/routes/paths";

export function AckCTA() {
  const me = useMe();
  const { checkIn } = useLoadedData();

  const ackOnLoad = shouldAcknowledgeOnLoad();
  const ackHandler = useAcknowledgeHandler(checkIn, ackOnLoad);

  if (checkIn.acknowledgedAt) return null;
  if (!checkIn.project!.permissions!.canAcknowledgeCheckIn) return null;
  if (!compareIds(checkIn.project!.reviewer!.id!, me!.id)) return null;
  if (ackOnLoad) return null;

  return (
    <div className="flex flex-row items-center justify-center mt-4 mb-4">
      <PrimaryButton size="lg" testId="acknowledge-check-in" onClick={ackHandler}>
        Acknowledge this Check-In
      </PrimaryButton>
    </div>
  );
}

function useAcknowledgeHandler(checkIn: ProjectCheckIns.ProjectCheckIn, ackOnLoad: boolean) {
  const refresh = useRefresh();
  const [ack] = ProjectCheckIns.useAcknowledgeProjectCheckIn();

  const handleAck = async () => {
    if (checkIn.acknowledgedAt) return;
    if (!checkIn.project!.permissions!.canAcknowledgeCheckIn) return;

    await ack({ id: checkIn.id });

    refresh();
  };

  //
  // If the user navigated to this page with ?acknowledge=true, acknowledge the check-in
  // immediately. This is useful for email links.
  //
  React.useEffect(() => {
    if (ackOnLoad) {
      handleAck();
    }
  }, []);

  return handleAck;
}

function shouldAcknowledgeOnLoad() {
  const search = new URLSearchParams(window.location.search);
  return search.get("acknowledge") === "true";
}
