import React, { createContext, useContext, useMemo } from "react";

import { useMe } from "@/contexts/CurrentUserContext";
import { Spacer } from "@/components/Spacer";
import { SubscriptionList } from "@/models/notifications";
import { NotifiablePerson } from "@/features/Subscriptions";
import { ExistingSubscriptionsList } from "./current-subscriptions/ExistingSubscriptionsList";
import { Subscribe } from "./current-subscriptions/Subscribe";
import { Unsubscribe } from "./current-subscriptions/Unsubscribe";

interface CurrentSubscriptionsProps {
  subscriptionList: SubscriptionList;
  name: "check-in" | "update" | "discussion";
  type: "project_check_in" | "goal_update" | "message";
  callback: () => void;
  people: NotifiablePerson[];
}

const CurrentSubscriptionsContext = createContext<CurrentSubscriptionsProps | undefined>(undefined);

export function useCurrentSubscriptionsContext() {
  const context = useContext(CurrentSubscriptionsContext);

  if (context === undefined) {
    throw Error("useCurrentSubscriptionsContext must be used within a CurrentSubscriptionsContext.Provider");
  }

  return context;
}

export function CurrentSubscriptions(props: CurrentSubscriptionsProps) {
  const me = useMe();
  const { subscriptions } = props.subscriptionList;

  const isSubscribed = useMemo(() => {
    return subscriptions?.map((s) => s.person?.id).includes(me?.id);
  }, [subscriptions]);

  return (
    <div>
      <CurrentSubscriptionsContext.Provider value={props}>
        <ExistingSubscriptionsList
          // The key is necessary because, when someone subscribes/unsubscribes or is mentioned in a comment,
          // this component must reload in order to update the "initially already selected" people
          key={String(isSubscribed) + subscriptions?.length}
        />
        <Spacer size={2} />

        {isSubscribed ? <Unsubscribe /> : <Subscribe />}
      </CurrentSubscriptionsContext.Provider>
    </div>
  );
}
